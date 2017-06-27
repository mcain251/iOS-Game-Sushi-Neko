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
    var sushiTower: [SushiPiece] = []
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Set reference to game objects
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        character = childNode(withName: "character") as! Character
        
        // Set up chopsticks for the sushi base and adds it to the stack
        sushiBasePiece.connectChopsticks()
        sushiTower.append(sushiBasePiece)
        
        // Test tower
        addRandomPieces(total: 7)
    }
    
    // Adds a new sushi on top of the sushi stack
    func addTowerPiece(side: Side) {
        
        // Copy base sushi piece
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        // Access last piece properties
        let lastPiece = sushiTower.last
        
        // Add on top of last piece, default on base piece
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        
        // Increment Z to ensure it's on top of the last piece, default on base piece
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        // Set sushi side
        newPiece.side = side
        
        // Add sushi to scene
        addChild(newPiece)
        
        // Add sushi piece to the sushi array
        sushiTower.append(newPiece)
    }
    
    // Adds "total" number of sushi rolls of ordered random chopstick location to the sushi stack
    func addRandomPieces(total: Int) {
        for _ in 1...total {
            
            // Access last piece properties
            let lastPiece = sushiTower.last!
            
            // Suggested method (doesn't allow for multiple rights/lefts in a row)
//            // Ensures we don't create impossible sushi structures
//            if lastPiece.side != .none {
//                addTowerPiece(side: .none)
//            } else {
//                
//                // RNG
//                let rand = arc4random_uniform(100)
//                if rand < 45 {
//                    // 45% Chance of a left piece
//                    addTowerPiece(side: .left)
//                } else if rand < 90 {
//                    // 45% Chance of a right piece
//                    addTowerPiece(side: .right)
//                } else {
//                    // 10% Chance of an empty piece
//                    addTowerPiece(side: .none)
//                }
//            }
            
            // RNG
            let rand = arc4random_uniform(100)
            
            // 45% Chance of a left piece
            if rand < 45  && lastPiece.side != .right {
                addTowerPiece(side: .left)
                
            // 45% Chance of a right piece
            } else if rand < 90 && rand >= 45 && lastPiece.side != .left {
                addTowerPiece(side: .right)
                
            // 10% Chance of an empty piece
            } else {
                addTowerPiece(side: .none)
            }
        }
    }
    
    // Called when a touch begins
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Isolates first touch
        let touch = touches.first!
        
        // Gets the location of the first touch
        let location = touch.location(in: self)
        
        // Calculates the side of the screen the touch was on, then moves the character to that side
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
    }
}
