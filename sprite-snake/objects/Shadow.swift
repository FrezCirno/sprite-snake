//
//  Shadow.swift
//  sprite-snake
//
//  Created by tzx on 2021/1/2.
//  Copyright © 2021 frezcirno. All rights reserved.
//

import Foundation
import SpriteKit

class Shadow {
    let scene: SKScene
    let snake: Snake
    var scale: CGFloat = 1
    
    let shadowNode = SKNode()
    var shadows = [SKSpriteNode]()
    var isLightingUp = false
    var lightStep = 0
    var maxLightStep = 3
    var lightUpdateCount = 0
    var updateLights = 3
    
    init(scene: SKScene, snake: Snake, scale: CGFloat) {
        self.scene = scene
        self.snake = snake
        
        for section in self.snake.sections {
            self.add(x: section.position.x, y: section.position.y)
        }

        snake.root.insertChild(self.shadowNode, at: 0)
        self.setScale(scale)
    }
    
    deinit {
        self.shadowNode.removeFromParent()
    }
    
    func add(x: CGFloat, y: CGFloat) {
        let shadow = SKSpriteNode(imageNamed: "white-shadow.png")
        shadow.setScale(self.scale)
        self.shadows.append(shadow)
        self.shadowNode.addChild(shadow)
    }
    
    func update() {
        var lastPos: CGPoint? = nil
        for i in 0..<self.snake.sections.count {
            let section = self.snake.sections[i]
            let pos = section.position
            let shadow = self.shadows[i]
            
            if lastPos != nil && lastPos == pos {
                shadow.alpha = 0
            } else {
                shadow.alpha = 1
            }
            shadow.position = pos
            lastPos = pos
        }
    }
    
    /**
     * Light up the shadow from a gray to a bright color
     */
    func lightUp() {
        self.lightUpdateCount = 0
        for i in 0..<self.shadows.count {
            let shadow = self.shadows[i]
            if shadow.alpha > 0 {
                if (i - self.lightStep) % self.maxLightStep == 0 {
                    shadow.colorBlendFactor = 1
                    shadow.color = UIColor(ciColor: CIColor(red: 22 / 255, green: 33 / 255, blue: 33 / 255))
                } else {
                    shadow.colorBlendFactor = 1
                    shadow.color = UIColor(ciColor: CIColor(red: 55 / 255, green: 33 / 255, blue: 33 / 255))
                }
            }
        }
        self.lightStep += 1
        if self.lightStep == self.maxLightStep {
            self.lightStep = 0
        }
    }
    
    func setScale(_ scale: CGFloat) {
        self.scale = scale
        for shadow in self.shadows {
            shadow.setScale(scale)
        }
    }
    
    
}
