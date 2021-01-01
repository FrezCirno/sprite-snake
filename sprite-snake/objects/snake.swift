//
//  snake.swift
//  sprite-snake
//
//  Created by sse-309-03 on 2020/12/31.
//  Copyright © 2020 frezcirno. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Snake {
    static var globalKey = 0
    static let slowSpeed = 150
    static let fastSpeed = 200
    static let rotateSpeed = 150
    static let initLength = 6
    static let distanceIndex = 17

    var scale = 0.5
    var speed = slowSpeed
    
    var globalKey:Int
    
    var preferredDistance = 0.0
    var headPath: [(Double, Double)] = []
    var queuedSections = 0.0
    var loss = 0.0
    
    var sectionGroup: [SKSpriteNode] = []
    var head: SKSpriteNode
    var lastHeadPosition: (Double, Double)
    
    var spriteKey = "circle"
    
    init(x:Double, y:Double, name:String) {
        self.globalKey = Snake.globalKey
        Snake.globalKey+=1
        
        //self.setScale(0.5)
        
        for _ in 0...Snake.initLength {
            _ = self.addSectionAtPosition(x:x, y:y,secSpriteKey: self.spriteKey) // 60x60
            self.headPath.append((x, y))
        }
    }
    
    /**
     * 更新时调用
     */
    func update() {
        
    
    }
    
    /**
     *
     */
    deinit{
    
    }

    func addSectionAtPosition(x:Double,y:Double,secSpriteKey:String = "circle") -> SKSpriteNode? {
        if let sec = SKSpriteNode(fileNamed: secSpriteKey) {
            sec.setScale(CGFloat(self.scale))
            self.sectionGroup.append(sec)
            return sec
        }
        return nil
    }
    
    func findNextPointIndex(currentIndex:Int) {
        
    }
    
    func onOneStepComplete() {
        
    }
    
    func setScale(_ scale: Double) {
        self.scale = scale
        self.preferredDistance = Double(Snake.distanceIndex) * self.scale
    }
    
    func incrementSize(amount: Double) {
        self.queuedSections += amount
    }
}
