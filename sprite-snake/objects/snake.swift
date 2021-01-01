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
    static let distanceIndex = 17.0

    var scale = 0.5
    var speed = slowSpeed
    
    var globalKey:Int
    
    var preferredDistance = 0.0
    var headPath: [(Double, Double)] = []
    var lastHeadPosition: (Double, Double) = (0,0)
    
    var queuedSections = 0.0
    var loss = 0.0
    
    var sections = SKNode()
    var head: SKSpriteNode? = nil
    
    var spriteKey = "circle"
    
    init(x:Double, y:Double, name:String) {
        self.globalKey = Snake.globalKey
        Snake.globalKey+=1
        
        self.setScale(0.5)
        
        for _ in 0...Snake.initLength {
            _ = self.addSectionAtPosition(x:x, y:y,secSpriteKey: self.spriteKey) // 60x60
            self.headPath.append((x, y))
        }
        
        self.head = self.sections.children.first as? SKSpriteNode
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
            self.sections.addChild(sec)
            return sec
        }
        return nil
    }
    
    
    func randColor() -> Int {
        let colors = [0xffff66, 0xff6600, 0x33cc33, 0x00ccff, 0xcc66ff]
        return colors[Int.random(in: 0...colors.count)]
    }
    
    
    func findNextPointIndex(currentIndex:Int) {
        
    }
    
    func onOneStepComplete() {
        
    }
    
    func setScale(_ scale: Double) {
        self.scale = scale
        self.preferredDistance = Snake.distanceIndex * self.scale
    }
    
    func incrementSize(amount: Double) {
        self.queuedSections += amount
    }
}
