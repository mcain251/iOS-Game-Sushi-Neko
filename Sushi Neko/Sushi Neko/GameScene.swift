//
//  GameScene.swift
//  Sushi Neko
//
//  Created by Marshall Cain on 6/27/17.
//  Copyright © 2017 Marshall Cain. All rights reserved.
//

import SpriteKit

// Tracks what side of the roll the chopsticks are on
enum Side {
    case left, right, none
}

class GameScene: SKScene {
    
    // Game objects
    var sushiBasePiece: SushiPiece!
    var character: Character!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Set reference to game objects
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        character = childNode(withName: "character") as! Character
        
        // Set up chopsticks for the sushi
        sushiBasePiece.connectChopsticks()
    }
    
}
