//
//  Food.swift
//  sprite-snake
//
//  Created by tzx on 2020/12/31.
//  Copyright © 2020 frezcirno. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit

var g_globalKey = 0

class BotSnake: Snake {

    override init(scene: SKScene, pos: CGPoint, name:String) {
        super.init(scene: scene, pos: pos, name: name)
    }
    
    
    func getRotateValue(rotation: CGFloat, prefRotation: CGFloat) -> CGFloat {
        var dif = prefRotation - rotation
        // 修正到-Pi,Pi之间
        if dif > CGFloat.pi {
            dif -= 2 * CGFloat.pi
        } else if dif < -CGFloat.pi {
            dif += 2 * CGFloat.pi
        }
        return dif
    }
    
    
    override func update() {
        
        var rot: CGFloat = 0 // 新的角速度
        let rotation = self.head!.zRotation // 当前的蛇头朝向(弧度),向右为0
        let pos = self.head!.position // 当前蛇头位置
        let scene = self.scene as! BattleScene
        
        // 吃食物
        let lb = vector2(Float(pos.x), Float(pos.y))
        let rt = vector2(Float(pos.x), Float(pos.y))
        let region = GKQuad(quadMin: lb, quadMax: rt)
        if let closestFood = scene.foodQuadTree.elements(in: region).first {
            var angleFood = CGVector.angleBetween(p1: pos, p2: closestFood.position)
            var dif = self.getRotateValue(rotation: rotation, prefRotation: angleFood)
            // 最大允许转过60度
            if (abs(dif) < CGFloat.pi / 3) {
                rot = dif
            }
        }

        // 防止撞车
        
        let bounding = GKQuad(quadMin: vector2(
                                Float(-scene.worldSize.width/2), Float(-scene.worldSize.height/2)),
                              quadMax: vector2(
                                Float(scene.worldSize.width/2), Float(scene.worldSize.height/2)))
        quadTree.elements(in: <#T##GKQuad#>)
        
        var closestOther = self.scene.physics.closest(self.head, self.others.reduce((res, other) => res.concat(other.getChildren()), []))
        if (closestOther) {
            var distOther = Phaser.Math.Distance.BetweenPoints(self.head, closestOther)
            var angleOther = CGVector.angleBetween(pos, closestOther)

            // 距离过近
            if (distOther < self.distcareness) {
                let dif = angleOther - rotation
                // 角度过近
                if (Math.abs(dif) < self.anglecareness) {
                    // 全力拐弯
                    rot = -Math.sign(dif) *  Double.pi
                    // console.log(self.globalkey + ' panic, and turn ' + (rot > 0 ? 'left' : 'right'))
                }
            }
        }

        // 防止撞墙
        var distWorldl = self.head?.position.x + self.scene.worldsize.x / 2
        var distWorldt = self.head?.position.y + self.scene.worldsize.y / 2
        var distWorldr = self.scene.worldsize.x / 2 - self.head?.position.x
        var distWorldb = self.scene.worldsize.y / 2 - self.head?.position.y
        var inTurn = 0
        if (distWorldl < self.worldBoundCareness || distWorldr < self.worldBoundCareness) {
            inTurn = 1
            if (!self.boundTurnTrend1) self.boundTurnTrend1 = Double.pi - rotation
            var dif = self.getRotateValue(rotation, self.boundTurnTrend1)
            rot = (rot ? (rot + dif) / 2 : dif)
        }
        if (distWorldt < self.worldBoundCareness || distWorldb < self.worldBoundCareness) {
            inTurn = 1
            if (!self.boundTurnTrend2) self.boundTurnTrend2 = -rotation
            var dif = self.getRotateValue(rotation, self.boundTurnTrend2)
            rot = (rot ? (rot + dif) / 2 : dif)
        }
        // 转弯完毕
        if (!inTurn) {
            self.boundTurnTrend1 = 0
            self.boundTurnTrend2 = 0
        }

        // 如果没动作, 则沿着感兴趣的方向前进
        if (!rot) {
            if (CGFloat.random() < 1 / 20) {
                self.trendRotation = (CGFloat.random() - 0.5) * 2 * Double.pi // 随便找个方向
            }
            rot = self.getRotateValue(rotation, self.trendRotation)
        }
        self.head.setAngularVelocity(rot * self.rotationSpeed)
        
        
        
        print(self.head?.physicsBody?.angularVelocity, self.head?.zRotation)
        super.update()
    }

    func destroy() {
    }

}
