//
//  Eye.swift
//  sprite-snake
//
//  Created by tzx on 2021/1/2.
//  Copyright © 2021 frezcirno. All rights reserved.
//

import Foundation
import SpriteKit

class Eye {
    let scene: GameScene
    
    var whiteCircle = SKSpriteNode(imageNamed: "eye-white.png")
    var blackCircle = SKSpriteNode(imageNamed: "eye-black.png")
    
    let head: SKSpriteNode
    let xoff: CGFloat
    let yoff: CGFloat
    
    let sizeInHeadCoord: CGSize
    
    init(scene: GameScene, head: SKSpriteNode, xoff: CGFloat, yoff: CGFloat) {
        self.scene = scene
        self.head = head
        self.xoff = xoff
        self.yoff = yoff
        self.sizeInHeadCoord = head.size
        self.whiteCircle.zPosition = 9999
        self.head.addChild(self.whiteCircle)
        self.blackCircle.zPosition = 9999
        self.whiteCircle.addChild(self.blackCircle)
    }
    
    func update() {
        // 自然坐标系，运动方向为x轴正方向
        // 眼白朝向运动方向
        self.whiteCircle.position = CGPoint(x: self.xoff * self.sizeInHeadCoord.width / 2, y: self.yoff * self.sizeInHeadCoord.width / 2)
        
        // 自然坐标系，运动方向为x轴正方向
        // 瞳孔朝向目标方向
        // scale
        let radius = (self.whiteCircle.size.width - self.blackCircle.size.width) / 2
        
        if let touchPos = self.scene.touchPos {
            let v_mouse = CGVector(dx: touchPos.x - self.head.position.x,
                                   dy: touchPos.y - self.head.position.y)
            let v_velocity = self.head.physicsBody!.velocity
            let v_cross = CGVector(dx: -v_velocity.dy, dy: v_velocity.dx)
            let x = v_mouse.proj(to: v_velocity)
            let y = v_mouse.proj(to: v_cross)
            self.blackCircle.position = CGVector(dx: x, dy: y).nomalize().scale(by: radius).asPoint()
        } else {
            self.blackCircle.position = CGPoint(x:radius, y: 0)
        }
    }
}
