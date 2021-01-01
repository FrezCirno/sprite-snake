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
    static let slowSpeed: CGFloat = 1.5
    static let fastSpeed: CGFloat = 2.0
    static let rotateSpeed: CGFloat = 1.5
    static let initLength = 6
    static let distanceIndex: CGFloat = 17.0

    var scale: CGFloat = 0.5
    var speed = slowSpeed
    
    var globalKey:Int
    
    var preferredDistance: CGFloat = 0.0
    var headPath: [CGPoint] = []
    var lastHeadPosition: CGPoint = CGPoint(x: 0,y: 0)
    
    var queuedSections = 0.0
    var loss = 0.0
    
    var root = SKNode()
    var sections = SKNode()
    var head: SKSpriteNode? = nil
    
//    var spriteKey = "circle"
    
    var detector = SKNode()
    var enemies: [SKNode] = []
    
    var label = SKLabelNode()
    
    let scene: SKScene
    
    init(scene: SKScene, pos: CGPoint, name:String) {
        self.globalKey = Snake.globalKey
        Snake.globalKey+=1
        
        self.scene = scene
        
        self.setScale(0.5)
        
        for _ in 0...Snake.initLength {
            _ = self.addSectionAtPosition(pos: pos, imageNamed: "circle.png") // 60x60
            self.headPath.append(pos)
        }
        self.head = self.sections.children.first as? SKSpriteNode
        self.root.addChild(self.sections)
        
        self.label.text = name
        self.root.addChild(self.label)
        
        
        self.detector.position = self.head!.position
        self.detector.alpha = 0
        self.detector.setScale(self.scale / 8)
        self.root.addChild(self.detector)
    }
    
    /**
     * 更新时调用
     *
     */
    func update() {
        // 子类只需要设置蛇头的角速度和speed即可
        // self.head?.physicsBody?.applyAngularImpulse()
        // 蛇的速度大小不会任意变化
        
//        var v = self.head?.physicsBody?.velocity
//        if v?.dx == 0 && v?.dy == 0 {
//            v = CGVector(dx: speed, dy: 0)
//        }
//        let dxSpeed = abs(CGFloat((v!.dx)))
//        let dySpeed = abs(CGFloat((v!.dy)))
//        let speed = sqrt(dxSpeed + dySpeed)
//        let radiansCon = atan(v!.dy / v!.dx)
        let radiansCon = self.head?.zRotation
//        let angleCon = radiansCon * 180 / Double.pi
        
        let dx = self.speed * cos(radiansCon!)
        let dy = self.speed * sin(radiansCon!)
        self.head?.physicsBody?.velocity = CGVector(dx: dx, dy: dy)

        let pos = self.head!.position
//        print(pos)
        self.label.position = CGPoint(x: pos.x, y: pos.y + 30)
    }
    
    /**
     *
     */
    deinit{
    
    }

    func addSectionAtPosition(pos: CGPoint, imageNamed: String = "circle.png") -> SKSpriteNode {
        let sec = SKSpriteNode(imageNamed: imageNamed)
        sec.position = pos
        sec.setScale(self.scale)
        sec.color = UIColor(red: CGFloat.random(in: 0.5...1),
                             green: CGFloat.random(in: 0.5...1),
                             blue: CGFloat.random(in: 0.5...1),
                             alpha: 1)
        sec.colorBlendFactor = 1
        sec.physicsBody = SKPhysicsBody(circleOfRadius: self.scale, center: pos)
        sec.physicsBody?.affectedByGravity = false
        sec.physicsBody?.mass = 1
        sec.physicsBody?.collisionBitMask = 0
        self.sections.addChild(sec)
        return sec
    }
    
    
    func randColor() -> Int {
        let colors = [0xffff66, 0xff6600, 0x33cc33, 0x00ccff, 0xcc66ff]
        return colors[Int.random(in: 0...colors.count)]
    }
    
    
    func findNextPointIndex(currentIndex:Int) {
        
    }
    
    func onOneStepComplete() {
        
    }
    
    func setScale(_ scale: CGFloat) {
        self.scale = scale
        self.preferredDistance = Snake.distanceIndex * self.scale
    }
    
    func incrementSize(amount: Double) {
        self.queuedSections += amount
    }
}
