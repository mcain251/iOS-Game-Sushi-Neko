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
    
}
