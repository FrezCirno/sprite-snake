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
    static let slowSpeed: CGFloat = 100
    static let fastSpeed: CGFloat = 300
    static let rotateSpeed: CGFloat = 2
    static let initLength = 6
    static let distanceIndex: CGFloat = 17.0

    var scale: CGFloat = 1
    var speed = slowSpeed
    
    var globalKey = 0
    
    var preferredDistance: CGFloat = 0.0
    var headPath = [CGPoint]()
    var lastHeadPosition = CGPoint(x: 0,y: 0)
    
    var queuedSections: CGFloat = 0.0
    var loss: CGFloat = 0.0
    
    var root = SKNode()
    var sectionsNode = SKNode()
    var sections = [SKSpriteNode]()
    var head: SKSpriteNode! = nil
    
    var eyes: EyePair! = nil
    var shadow: Shadow! = nil
    
//    var spriteKey = "circle"
    
    var detector = SKSpriteNode(color: .red, size: CGSize(width: 1, height: 1))
    var enemies = [SKNode]()
    
    var label = SKLabelNode()
    
    let scene: BattleScene
    
    init(scene: BattleScene, pos: CGPoint, name:String) {
        self.scene = scene
        
        for _ in 0..<Snake.initLength {
            _ = self.addSectionAtPosition(pos: pos) // 60x60
            self.headPath.append(pos)
        }
        self.head = self.sections.first
        self.head.physicsBody?.categoryBitMask |= Category.Head.rawValue
        self.head.physicsBody?.collisionBitMask = 0
        self.head.physicsBody?.contactTestBitMask |= Category.Food.rawValue
    
        self.eyes = EyePair(scene: self.scene, head: self.head, scale: self.scale)
        self.root.addChild(self.sectionsNode)
        
        self.label.text = name
        self.label.fontColor = .black
        self.label.zPosition = 9999
        self.root.addChild(self.label)
        
        self.detector.position = CGPoint(x: self.head.size.width, y: 0)
        self.detector.size = CGSize(width: self.head.size.width/10, height: self.head.size.height/10)
        self.detector.alpha = 1 // Hide
        self.detector.setScale(self.scale)
        self.detector.userData = NSMutableDictionary()
        self.detector.userData?.setValue(self, forKey: "snake")
        self.detector.physicsBody = SKPhysicsBody(circleOfRadius: self.detector.size.width/2, center: self.detector.position)
        self.detector.physicsBody?.categoryBitMask = Category.Detector.rawValue
        self.detector.physicsBody?.collisionBitMask = 0
        self.detector.physicsBody?.contactTestBitMask = Category.Sections.rawValue
        self.head.addChild(self.detector)
        
        self.shadow = Shadow(scene: self.scene, snake: self, scale: self.scale)
        self.setScale(0.5)
    }
    
    /**
     * 更新时调用
     */
    func update() {
        // 子类只需要设置蛇头的角速度和speed即可
        // 蛇的速度大小不会任意变化
        
        // 使速度方向（Velocity）与蛇头朝向（zRotation）一致
        // 此处的速度是基于parent的坐标系（右上为正）
        let zRotation = self.head.zRotation
        let dx = self.speed * cos(zRotation)
        let dy = self.speed * sin(zRotation)
        self.head.physicsBody?.velocity = CGVector(dx: dx, dy: dy)

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
            self.headPath.removeSubrange(index+1..<self.headPath.count)
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
        
        self.label.position = CGPoint(x: self.head.position.x, y: self.head.position.y + 30)
        self.detector.position = CGPoint(x: self.head.size.width, y: 0)
        
        self.eyes.update()
        self.shadow.update()
    }
    
    func destroy() {
        
    }

    func addSectionAtPosition(pos: CGPoint, imageNamed: String = "circle.png") -> SKSpriteNode {
        let sec = SKSpriteNode(imageNamed: imageNamed) // 60x60
        sec.name = "sections"
        sec.position = pos
        sec.setScale(self.scale)
        sec.color = UIColor(red: CGFloat.random(in: 0.5...1),
                             green: CGFloat.random(in: 0.5...1),
                             blue: CGFloat.random(in: 0.5...1),
                             alpha: 1)
        sec.colorBlendFactor = 1
        sec.zPosition = 100
        sec.userData = NSMutableDictionary()
        sec.userData?.setValue(self, forKey: "snake")
        sec.physicsBody = SKPhysicsBody(circleOfRadius: sec.size.width / 2)
        sec.physicsBody?.affectedByGravity = false
        sec.physicsBody?.mass = 1
        sec.physicsBody?.categoryBitMask = Category.Sections.rawValue
        sec.physicsBody?.collisionBitMask = 0
        sec.physicsBody?.contactTestBitMask = Category.Detector.rawValue
        self.sections.append(sec)
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
        let seclen = self.sections.count
        if seclen < Snake.initLength {
            self.queuedSections -= CGFloat((self.speed == Snake.fastSpeed ? seclen / 10 : seclen / 100))
        }

        if (self.queuedSections >= 1) {
            let last = self.sections.last!
            _ = self.addSectionAtPosition(pos: last.position)

            // 动态增长效果
            let length = self.headPath.count
            for i in (0..<length).reversed() {
                if (last.position == self.headPath[i]) {
                    self.headPath.removeSubrange(i+1..<length)
                    break
                }
            }

            self.shadow.add(x: last.position.x, y: last.position.y)

            self.setScale(self.scale * 1.01);
            self.queuedSections-=1

        } else if self.queuedSections <= -1 {
            let last = self.sections.last!

            let loss = CGFloat.random(in: 0.5 ... -self.queuedSections)
            _ = self.scene.createFood(amount: loss)

            self.loss += loss
            if self.loss >= 1 {
                last.removeFromParent()
                _ = self.sections.popLast()

//                let ls = self.shadow.shadowGroup.getLast(true);
//                self.shadow.shadowGroup.remove();
//                ls.destroy();

                self.setScale(self.scale * 0.99)
                self.loss = 0
            }

            self.queuedSections += loss
        }
    }
    
    func setScale(_ scale: CGFloat) {
        self.scale = scale
        self.preferredDistance = Snake.distanceIndex * self.scale
        self.sections.forEach { $0.setScale(scale) }
        self.detector.setScale(scale)
//        self.eyes.setScale(scale)
        self.shadow.setScale(scale)
    }
    
    func incrementSize(amount: CGFloat) {
        self.queuedSections += amount
    }
}
