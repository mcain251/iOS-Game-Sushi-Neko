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

// Track game state
enum GameState {
    case title, ready, playing, gameOver
}

// Game state
var state: GameState = .title

class GameScene: SKScene {
    
    // Game objects and variables
    var sushiBasePiece: SushiPiece!
    var character: Character!
    var sushiTower: [SushiPiece] = []
    var playButton: MSButtonNode!
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE")
    var healthBar: SKSpriteNode!
    var health: CGFloat = 1.0 {
        didSet {
            if health > 1.0 {
                health = 1.0
            }
            healthBar.xScale = health
        }
    }
    
    // Death sound effect
    let deathSound = SKAction.playSoundFileNamed("364929__josepharaoh99__game-die", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Set reference to game objects
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        character = childNode(withName: "character") as! Character
        playButton = childNode(withName: "playButton") as! MSButtonNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        highScoreLabel = childNode(withName: "highScoreLabel") as! SKLabelNode
        
        // Set up chopsticks for the sushi base and adds it to the stack
        sushiBasePiece.connectChopsticks()
        
        // Set up sushi tower
        addTowerPiece(side: .none)
        addRandomPieces(total: 9)
        
        // Play button functionality
        playButton.selectedHandler = {
            
            // Start game
            state = .ready
        }
    }
    
    
    // Called when a touch begins
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Check that game is ready
        if state == .gameOver || state == .title { return }
        
        // Game begins on first touch
        if state == .ready {
            state = .playing
        }
        
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
        
        // Grab sushi piece on top of the base sushi piece, it will always be 'first'
        if let firstPiece = sushiTower.first {
            
            // Check if player has touched a chopstick
            if state != .gameOver && character.side == sushiTower.first!.side {
                state = .gameOver
                gameOver()
                return
            }
            
            // Remove from sushi tower array
            sushiTower.removeFirst()
            
            // Animate the punched sushi piece
            firstPiece.flip(character.side)
            
            // Add a new sushi piece to the top of the sushi tower
            addRandomPieces(total: 1)
            
            // Lowers the sushis' z-positions
            for piece in sushiTower {
                piece.zPosition -= 1
            }
            
            // Increment Health
            health += 0.075
            
            // Increment Score
            score += 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveTowerDown()
        highScoreLabel.text = "High: \(highScore)"
        
        if state != .playing {
            if state == .ready {
                playButton.state = .MSButtonNodeStateHidden
            } else {
                playButton.state = .MSButtonNodeStateActive
            }
            return
        }
        playButton.state = .MSButtonNodeStateHidden
        
        // Decrease Health
        health -= 0.01
        
        // Check if player ran out of health
        if health <= 0 {
            state = .gameOver
            gameOver()
        }
        
        // Check if player has touched a chopstick
        if state != .gameOver && character.side == sushiTower.first!.side {
            state = .gameOver
            gameOver()
        }
        
        // Updates and displays the high score
        if score > highScore {
            UserDefaults.standard.set(score, forKey: "HIGHSCORE")
            highScore = UserDefaults().integer(forKey: "HIGHSCORE")
            highScoreLabel.text = "High: \(highScore)"
        }
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
    
    // Moves sushi tower down after hit
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    
    // Called when player loses
    func gameOver() {
        
        // Play sound effect
        run(deathSound)
        
        // Have the sushi fall in random directions
        for _ in sushiTower {
            if let firstPiece = sushiTower.first {
                sushiTower.removeFirst()
                let rand = arc4random_uniform(2)
                if rand == 1 {
                    firstPiece.fall(.right)
                }
                else{
                    firstPiece.fall(.left)
                }
            }
        }
        
        // Make the base fall
        sushiBasePiece.fall(character.side)
        
        // Make the player turn red
        character.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        
        // Change play button selection handler
        playButton.selectedHandler = {
            
            // Makes the game ready to play again
            state = .ready
            
            // Grab reference to the SpriteKit view
            let skView = self.view as SKView!
            
            // Load Game scene
            guard let scene = GameScene(fileNamed:"GameScene") as GameScene! else {
                return
            }
            
            // Ensure correct aspect mode
            scene.scaleMode = .aspectFill
            
            // Restart GameScene
            skView?.presentScene(scene)
        }
    }
}
