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

    let careness = CGFloat.random(in: 0...1)
    let distcareness = CGFloat.random(in: 100...600)
    let anglecareness = CGFloat.random(in: 0.5...1) * CGFloat.pi / 4
    let worldBoundCareness: CGFloat
    
    var boundTurnTrend1: CGFloat = 0
    var boundTurnTrend2: CGFloat = 0
    var trendRotation: CGFloat = 0
    
    
    override init(scene: GameScene, pos: CGPoint, name:String) {
        self.worldBoundCareness = CGFloat.random(in: 100...max(100,min(scene.worldSize.width, scene.worldSize.height)/50))
        
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
        let scene = self.scene
        
        // 吃食物
        let lb = vector2(Float(pos.x), Float(pos.y))
        let rt = vector2(Float(pos.x), Float(pos.y))
        let region = GKQuad(quadMin: lb, quadMax: rt)
        if let closestFood = scene.foodQuadTree.elements(in: region).first {
            let angleFood = CGVector.angleBetween(p1: pos, p2: closestFood.position)
            let dif = self.getRotateValue(rotation: rotation, prefRotation: angleFood)
            // 最大允许转过60度
            if (abs(dif) < CGFloat.pi / 3) {
                rot = dif
            }
        }

        // 防止撞车
        let res = scene.closestSnakes(pos: pos).filter({ $0 !== self as Snake })
        if let snake = res.first {
            let distOther = CGVector.distanceBetween(p1: pos, p2: snake.head!.position)
            let angleOther = CGVector.angleBetween(p1: pos, p2: snake.head!.position)

            // 距离过近
            if (distOther < self.distcareness) {
                let dif = angleOther - rotation
                // 角度过近
                if (abs(dif) < self.anglecareness) {
                    // 全力拐弯
                    rot = CGFloat(-sign(Float(dif))) * CGFloat.pi
                    // console.log(self.globalkey + ' panic, and turn ' + (rot > 0 ? 'left' : 'right'))
                }
            }
        }

        // 防止撞墙
        let distWorldl = self.head.position.x + scene.worldSize.width / 2
        let distWorldt = self.head.position.y + scene.worldSize.height / 2
        let distWorldr = scene.worldSize.width / 2 - self.head.position.x
        let distWorldb = scene.worldSize.height / 2 - self.head.position.y
        
        var inTurn = 0
        if distWorldl < self.worldBoundCareness || distWorldr < self.worldBoundCareness {
            inTurn = 1
            if self.boundTurnTrend1 == 0 {
                self.boundTurnTrend1 = CGFloat.pi - rotation
            }
            let dif = self.getRotateValue(rotation: rotation, prefRotation: self.boundTurnTrend1)
            rot = (rot != 0 ? (rot + dif) / 2 : dif)
        }
        if distWorldt < self.worldBoundCareness || distWorldb < self.worldBoundCareness {
            inTurn = 1
            if self.boundTurnTrend2 == 0 {
                self.boundTurnTrend2 = -rotation
            }
            let dif = self.getRotateValue(rotation: rotation, prefRotation: self.boundTurnTrend2)
            rot = (rot != 0 ? (rot + dif) / 2 : dif)
        }
        // 转弯完毕
        if inTurn == 0 {
            self.boundTurnTrend1 = 0
            self.boundTurnTrend2 = 0
        }

        // 如果没动作, 则沿着感兴趣的方向前进
        if (rot == 0) {
            if (CGFloat.random(in: 0...1) < 1 / 20) {
                self.trendRotation = CGFloat.random(in: -1...1) * CGFloat.pi // 随便找个方向
            }
            rot = self.getRotateValue(rotation: rotation, prefRotation: self.trendRotation)
        }
        
        self.head.physicsBody?.angularVelocity = rot * Snake.rotateSpeed
    
//        print(self.head?.physicsBody?.angularVelocity, self.head?.zRotation)
        
        super.update()
    }
}
