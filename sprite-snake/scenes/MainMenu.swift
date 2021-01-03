////
////  MenuScene.swift
////  sprite-snake
////
////  Created by tzx on 2021/1/3.
////  Copyright © 2021 frezcirno. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//import GameplayKit
//
//class MainMenu: SKScene {
//
//    /* UI Connections */
//    var buttonPlay: MSButtonNode
//
//    override func didMove(to view: SKView) {
//        /* Setup your scene here */
//
//        // 填充背景
//        let map = SKNode()
//
//        let tileSet = SKTileSet(named: "My Grid Tile Set")!
//        let tileTiles = tileSet.tileGroups.first { $0.name == "Tile" }
//
//        let tileSize = CGSize(width: 40, height: 40)
//        let columns = Int(self.worldSize.width / tileSize.width)
//        let rows = Int(self.worldSize.height / tileSize.height)
//
//        let bottonLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
//        bottonLayer.fill(with: tileTiles)
//        map.addChild(bottonLayer)
//        map.position = CGPoint(x: 0, y: 0)
//
//        addChild(map)
//
//        /* Set UI connections */
//        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
//        buttonPlay.selectedHandler = {
//            self.loadGame()
//        }
//    }
//
//    func loadGame() {
//        let skView = self.view as SKView!
//        let scene = GameScene(fileNamed:"GameScene")!
//
//        scene.scaleMode = .aspectFill
//
//        skView.showsPhysics = true
//        skView.showsDrawCount = true
//        skView.showsFPS = true
//
//        skView.presentScene(scene)
//    }
//}
