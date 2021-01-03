//
//  MenuScene.swift
//  sprite-snake
//
//  Created by tzx on 2021/1/1.
//  Copyright © 2021 frezcirno. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MenuScene: SKScene {

    override func didMove(to view: SKView) { /* ... */}

    func selectLevel(level: Int) {
        let fadeTransition = SKTransition.fade(withDuration: 0.3)
        if let selectedLevel = createLevelSceneWithLevel(level: level) {
            self.view?.presentScene(selectedLevel, transition: fadeTransition)
        }
    }


    // Not a good idea if you progressively adding new levels,
    // it's totally depend on how you gonna organize your levels.
    // Since its level input is not arbitrary, the output of this
    // rarely nil, if it does, it must be the developer mistake.
    func createLevelSceneWithLevel(level: Int) -> SKScene? {
        let levelScene: SKScene?
        switch level {
//            case 1: levelScene = Level1()
//            case 2: levelScene = Level2()
            default: levelScene = nil
        }
        return levelScene
    }

}
