//
//  snake.swift
//  sprite-snake
//
//  Created by sse-309-03 on 2020/12/31.
//  Copyright © 2020 frezcirno. All rights reserved.
//

import Foundation

var g_globalKey = 0

class Snake {
    static let slowSpeed = 150;
    static let fastSpeed = 200;
    static let rotateSpeed = 150;
    static let initLength = 6;
    static let distanceIndex = 17;

    var scale = 0.5;
    var speed = slowSpeed;
    
    var globalKey:Int;
    
    var preferredDistance: Double;
    var headPath: [Int];
    var queuedSections = 0.0;
    var loss = 0.0;
    
    var sectionGroup: [rb_node];
    
    init(x:Float, y:Float, name:String) {
        self.globalKey = g_globalKey;
        g_globalKey+=1;
        
        self.setScale(0.5);
        
    }
    
    /**
     * 更新时调用
     */
    func update() {
        
    
    }
    
    /**
     *
     */
    func destroy(){
    
    }

    func addSectionAtPosition(x:Int, y:Int, secSpriteKey:String = "circle") {
        
    }
    
    func findNextPointIndex(currentIndex:Int) {
        
    }
    
    func onOneStepComplete() {
        
    }
    
    func setScale(_ scale: Double) {
        self.scale = scale;
        self.preferredDistance = Double(Snake.distanceIndex) * self.scale;
    }
    
    func incrementSize(amount: Double) {
        self.queuedSections += amount;
    }
}
