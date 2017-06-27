//
//  SushiPiece.swift
//  Sushi Neko
//
//  Created by Marshall Cain on 6/27/17.
//  Copyright © 2017 Marshall Cain. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {
    
    // Chopstick location
    var side: Side = .none {
        didSet {
            switch side {
            case .left:
                
                // Show only left chopstick
                leftChopstick.isHidden = false
            case .right:
                
                // Show only right chopstick
                rightChopstick.isHidden = false
            case .none:
                
                // Hide both chopsticks
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            }
        }
    }
    
    // Chopstick objects
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    // Initializer
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    // Required to inherit SKSpriteNode
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Set reference to chopsticks
    func connectChopsticks() {
        rightChopstick = childNode(withName: "rightChopstick") as! SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as! SKSpriteNode
        
        // Set the default as no chopsticks
        side = .none
    }
    
    // Remove the sushi from the screen
    func flip(_ side: Side) {
        
        // Decide which direction to flip
        var actionName: String = ""
        if side == .left {
            actionName = "FlipRight"
        } else if side == .right {
            actionName = "FlipLeft"
        }
        
        // Load appropriate action
        let flip = SKAction(named: actionName)!
        
        // Create a node removal action
        let remove = SKAction.removeFromParent()
        
        // Build sequence, flip then remove from scene
        let sequence = SKAction.sequence([flip,remove])
        run(sequence)
    }
    
    // Remove the sushi from the screen on gameover
    func fall(_ side: Side) {
        
        // Decide which direction to fall
        var actionName: String = ""
        if side == .left {
            actionName = "FallRight"
        } else if side == .right {
            actionName = "FallLeft"
        }
        
        // Load appropriate action
        let flip = SKAction(named: actionName)!
        
        // Create a node removal action
        let remove = SKAction.removeFromParent()
        
        // Build sequence, flip then remove from scene
        let sequence = SKAction.sequence([flip,remove])
        run(sequence)
    }
}
