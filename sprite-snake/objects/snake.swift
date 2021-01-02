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
    static let slowSpeed: CGFloat = 0.5
    static let fastSpeed: CGFloat = 1.5
    static let rotateSpeed: CGFloat = 0.1
    static let initLength = 6
    static let distanceIndex: CGFloat = 17.0

    var scale: CGFloat = 0.5
    var speed = slowSpeed
    
    var globalKey:Int
    
    var preferredDistance: CGFloat = 0.0
    var headPath: [CGPoint] = []
    var lastHeadPosition: CGPoint = CGPoint(x: 0,y: 0)
    
    var queuedSections: CGFloat = 0.0
    var loss: CGFloat = 0.0
    
    var root = SKNode()
    var sectionsNode = SKNode()
    var sections: [SKSpriteNode] = []
    var head: SKSpriteNode! = nil
    
//    var spriteKey = "circle"
    
    var detector = SKSpriteNode(color: .red, size: CGSize(width: 1, height: 1))
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
        self.head = self.sections.first
        self.head.physicsBody?.categoryBitMask = Category.Sections.rawValue
        self.head.physicsBody?.collisionBitMask = 0
        self.head.physicsBody?.contactTestBitMask = Category.Food.rawValue
        self.root.addChild(self.sectionsNode)
        
        self.label.text = name
        self.label.fontColor = .black
        self.root.addChild(self.label)
        
        self.detector.position = self.head!.position
        self.detector.size = self.head.size
//        self.detector.alpha = 0 // Hide
        self.detector.setScale(self.scale)
        self.detector.physicsBody = SKPhysicsBody(circleOfRadius: self.detector.size.width/2, center: self.detector.position)
        self.detector.physicsBody?.categoryBitMask = Category.Detector.rawValue
        self.detector.physicsBody?.collisionBitMask = 0
        self.detector.physicsBody?.contactTestBitMask = Category.Sections.rawValue
        self.root.addChild(self.detector)
    }
    
    /**
     * 更新时调用
     */
    func update() {
        // 子类只需要设置蛇头的角速度和speed即可
        // 蛇的速度大小不会任意变化
        let radiansCon = self.head?.zRotation
        let dx = self.speed * cos(radiansCon!)
        let dy = self.speed * sin(radiansCon!)
        self.head?.physicsBody?.velocity = CGVector(dx: dx, dy: dy)

        // 把路径上的最后一个节点移到最开头
        if var point = self.headPath.popLast() {
            point.x = self.head.position.x
            point.y = self.head.position.y
            self.headPath.insert(point, at: 0)
        }

        // 放置蛇身
        var index = self.findNextPointIndex(currentIndex: 0)
        var lastIndex: Int? = nil;
        for section in self.sections[1..<self.sections.count] {
            section.position.x = self.headPath[index].x;
            section.position.y = self.headPath[index].y;

            //hide sections if they are at the same position
            if lastIndex != nil && index == lastIndex {
                section.alpha = 0
            }
            else {
                section.alpha = 1
            }
            lastIndex = index
            index = self.findNextPointIndex(currentIndex: index)
        }

        // 如果index到头了, 说明headPath的长度不够, +1个
        if index + 1 >= self.headPath.count {
            let lastPos = self.headPath.last!
            self.headPath.append(CGPoint(x: lastPos.x, y: lastPos.y))
        } else if index < self.headPath.count {
            self.headPath.removeSubrange(index..<self.headPath.count)
            assert(self.headPath.count > 0)
        }

        // 检查需不需要增长
        // 在前两节之间的路径点里
        // 寻找lastHeadPosition
        var found = false;
        for headPathPoint in self.headPath {
            if (headPathPoint.x == self.lastHeadPosition.x && headPathPoint.y == self.lastHeadPosition.y) {
                found = true;
                break;
            }
        }
        if (!found) {
            self.lastHeadPosition = CGPoint(x: self.headPath[0].x, y: self.headPath[0].y)
            self.onOneStepComplete()
        }
        print(self.headPath.count)
        
        self.label.position = CGPoint(x: self.head.position.x, y: self.head.position.y + 30)
        self.detector.position = CGPoint(x: self.head.position.x + 40 * cos(radiansCon!), y: self.head.position.y + 40 * sin(radiansCon!))
    }
    
    /**
     *
     */
    deinit {
        
    }

    func addSectionAtPosition(pos: CGPoint, imageNamed: String = "circle.png") -> SKSpriteNode {
        let sec = SKSpriteNode(imageNamed: imageNamed)
        sec.name = "sections"
        sec.position = pos
        sec.setScale(self.scale)
        sec.color = UIColor(red: CGFloat.random(in: 0.5...1),
                             green: CGFloat.random(in: 0.5...1),
                             blue: CGFloat.random(in: 0.5...1),
                             alpha: 1)
        sec.colorBlendFactor = 1
        sec.userData = NSMutableDictionary()
        sec.userData?.setValue(self, forKey: "snake")
        sec.physicsBody = SKPhysicsBody(circleOfRadius: self.scale, center: pos)
        sec.physicsBody?.affectedByGravity = false
        sec.physicsBody?.mass = 1
        sec.physicsBody?.categoryBitMask = Category.Sections.rawValue
        sec.physicsBody?.collisionBitMask = 0
        sec.physicsBody?.contactTestBitMask = 0
        self.sections.insert(sec, at: 0)
        self.sectionsNode.insertChild(sec, at: 0)
        return sec
    }
    
    
    func randColor() -> Int {
        let colors = [0xffff66, 0xff6600, 0x33cc33, 0x00ccff, 0xcc66ff]
        return colors[Int.random(in: 0...colors.count)]
    }
    
    
    func findNextPointIndex(currentIndex:Int) -> Int {
        
        //we are trying to find a point at approximately self distance away
        //from the point before it, where the distance is the total length of
        //all the lines connecting the two points
        var nowLen: CGFloat = 0;
        var lastDiff: CGFloat? = nil;
        var diff = nowLen - self.preferredDistance;
        //self loop sums the distances between points on the path of the head
        //starting from the given index of the function and continues until
        //self sum nears the preferred distance between two snake sections
        var i = currentIndex
        
        while i + 1 < self.headPath.count && diff < 0 {
            //get distance between next two points
            let dist = CGVector.distanceBetween(p1: self.headPath[i], p2: self.headPath[i + 1])
            nowLen += dist; // 距离=折线段长度之和
            lastDiff = diff;
            diff = nowLen - self.preferredDistance;
            i += 1
        }
        // |lastDiff| >= |diff|说明当前结果更优
        // 边界情况: lastDiff===null说明headPath为空
        if (lastDiff == nil || abs(lastDiff!) >= abs(diff)) {
            return i;
        }
        else {
            return i - 1;
        }
    }
    
    func onOneStepComplete() {
        
    }
    
    func setScale(_ scale: CGFloat) {
        self.scale = scale
        self.preferredDistance = Snake.distanceIndex * self.scale
    }
    
    func incrementSize(amount: CGFloat) {
        self.queuedSections += amount
    }
}
