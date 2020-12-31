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
    var queuedSections = 0;
    var loss = 0;
    
    var sectionGroup: [rb_node];
    
    init(x:Float, y:Float, name:String) {
        self.scale = 0.5;
        self.globalKey = g_globalKey;
        g_globalKey+=1;
        self.preferredDistance = Snake.distanceIndex * self.scale;
        
    }
    
    func update() {
        
    
    }

    

}
