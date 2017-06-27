//
//  Character.swift
//  Sushi Neko
//
//  Created by Marshall Cain on 6/27/17.
//  Copyright © 2017 Marshall Cain. All rights reserved.
//

import SpriteKit

class Character: SKSpriteNode {
    
    // Character location
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 70
            } else {
                xScale = -1
                position.x = 252
            }
        }
    }
    
    // Initializer
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    // Required to inherit SKSpriteNode
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
