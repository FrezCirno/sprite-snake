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

    override init(x:Double, y:Double, name:String) {
        super.init(x: x,y: y,name: name)
    }


    func destroy() {
    }

}
