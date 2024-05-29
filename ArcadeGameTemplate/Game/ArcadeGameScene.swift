//
//  ArcadeGameScene.swift
//  ArcadeGameTemplate
//

import SpriteKit
import SwiftUI

struct PhysicsCategory{
    static let none : UInt32 = 1
    static let all : UInt32 = UInt32.max
    static let duck : UInt32 = 2
    static let obstacle : UInt32 = 4
    static let coin : UInt32 = 8
}

class ArcadeGameScene: SKScene {
    /**
     * # The Game Logic
     *     The game logic keeps track of the game variables
     *   you can use it to display information on the SwiftUI view,
     *   for example, and comunicate with the Game Scene.
     **/
    
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    
    var coinSound = SKAction.playSoundFileNamed("COIN", waitForCompletion: false)
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    
    var duck: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.setUpGame()
        self.setUpPhysicsWorld()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // ...
        
        // If the game over condition is met, the game will finish
        if self.isGameOver { self.finishGame() }
        
        // The first time the update function is called we must initialize the
        // lastUpdate variable
        if self.lastUpdate == 0 { self.lastUpdate = currentTime }
        
        // Calculates how much time has passed since the last update
        let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
        // Increments the length of the game session at the game logic
        self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
    }
}

// MARK: - Game Scene Set Up
extension ArcadeGameScene {
    
    private func setUpGame() {
        let soundTrack = SKAudioNode(fileNamed: "Soundtrack")
        addChild(soundTrack)
        
        self.gameLogic.setUpGame()

        let backgroundTexture1 = SKTexture(imageNamed: "Road1")
        let backgroundTexture2 = SKTexture(imageNamed: "Road2")
        let backgroundTextures = [backgroundTexture1, backgroundTexture2]

        let backgroundImage = SKSpriteNode(texture: backgroundTexture1)
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.size = self.frame.size
        backgroundImage.zPosition = -1
        addChild(backgroundImage)

        let crossfadeAction = SKAction.animate(with: backgroundTextures, timePerFrame: 0.3)
        let repeatAction = SKAction.repeatForever(crossfadeAction)
        backgroundImage.run(repeatAction)

        let playerInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/6)
        self.createPlayer(at: playerInitialPosition)

        let delayAction = SKAction.wait(forDuration: 10.0)
        let startCoinCycleAction = SKAction.run {
            self.startCoinCycle()
        }
        let sequence = SKAction.sequence([delayAction, startCoinCycleAction])
        self.run(sequence)

        self.startObstacleCycle()
    }
    
    private func setUpPhysicsWorld() {
        // TODO: Customize!
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        physicsWorld.contactDelegate = self
    }
    
    private func restartGame() {
        self.gameLogic.restartGame()
    }
    
    private func createPlayer(at position: CGPoint) {
        
        let duckTexture1 = SKTexture(imageNamed: "PaperaP1")
        let duckTexture2 = SKTexture(imageNamed: "PaperaP2")

        let duckAnimationTextures = [duckTexture1, duckTexture2]

        self.duck = SKSpriteNode(texture: duckTexture1)
        duck.xScale = 0.07
        duck.yScale = 0.07
        self.duck.name = "player"
        self.duck.position = position

        duck.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        duck.physicsBody?.affectedByGravity = false
        duck.physicsBody?.categoryBitMask = PhysicsCategory.duck
        duck.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle
        duck.physicsBody?.collisionBitMask = PhysicsCategory.obstacle

        let duckAnimation = SKAction.animate(with: duckAnimationTextures, timePerFrame: 0.2)
        let repeatAction = SKAction.repeatForever(duckAnimation)
        duck.run(repeatAction)

        addChild(self.duck)
    }
    
    func startCoinCycle() {
        let createAsteroidAction = SKAction.run(createCoin)
        let waitAction = SKAction.wait(forDuration:  Double.random(in: 2...5))
        
        let createAndWaitAction = SKAction.sequence([createAsteroidAction, waitAction])
        let asteroidCoinAction = SKAction.repeatForever(createAndWaitAction)
        
        run(asteroidCoinAction)
    }
    
    func startObstacleCycle() {
        let createObstacleAction = SKAction.run(createObstacle)
        let waitDuration = Double.random(in: 0.5...1)
        let waitAction = SKAction.wait(forDuration: waitDuration)
        
        let createAndWaitAction = SKAction.sequence([createObstacleAction, waitAction])
        let asteroidObstacleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(asteroidObstacleAction)
    }
}

// MARK: - Handle Player Inputs
extension ArcadeGameScene {

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            duck.position.x = touch.location(in: self).x
        }
    }
}


// MARK: - Game Over Condition
extension ArcadeGameScene {
    
    /**
     * Implement the Game Over condition.
     * Remember that an arcade game always ends! How will the player eventually lose?
     *
     * Some examples of game over conditions are:
     * - The time is over!
     * - The player health is depleated!
     * - The enemies have completed their goal!
     * - The screen is full!
     **/
    
    var isGameOver: Bool {
        // TODO: Customize!
        
        // Did you reach the time limit?
        // Are the health points depleted?
        // Did an enemy cross a position it should not have crossed?
        
        return gameLogic.isGameOver
    }
    
    private func finishGame() {
        
        // TODO: Customize!
        
        gameLogic.isGameOver = true
    }
    
}

// MARK: - Register Score
extension ArcadeGameScene {
    
    private func registerScore() {
        gameLogic.currentScore += 1
    }
    
}

// MARK: - Asteroids
extension ArcadeGameScene {
    
    private func createCoin() {
        let coinPosition = self.randomCoinPosition()
        newCoin(at: coinPosition)
    }
    
    private func randomCoinPosition() -> CGPoint {
        let initialX: CGFloat = 25
        let finalX: CGFloat = self.frame.width - 25
        
        let positionX = CGFloat.random(in: initialX...finalX)
        let positionY = frame.height - 25
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func newCoin(at position: CGPoint) {
        var coinTextures: [SKTexture] = []
        
        for i in 1 ..< 9 {
            coinTextures.append(SKTexture(imageNamed: "coin\(i)"))
        }
        
        let animationAction = SKAction.animate(with: coinTextures, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(animationAction)

        let newCoin = SKSpriteNode(texture: coinTextures.first)
        newCoin.position = position
        newCoin.name = "coin"
        newCoin.xScale = 0.3
        newCoin.yScale = 0.3

        newCoin.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        newCoin.physicsBody?.affectedByGravity = true
        newCoin.physicsBody?.categoryBitMask = PhysicsCategory.coin
        newCoin.physicsBody?.contactTestBitMask = PhysicsCategory.duck
        newCoin.physicsBody?.collisionBitMask = PhysicsCategory.duck
        
        newCoin.physicsBody?.velocity.dy = -150
        addChild(newCoin)

        newCoin.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.0),
            repeatAction,
            SKAction.wait(forDuration: 5.0),
            SKAction.removeFromParent()
        ]))
    }
    
}

extension ArcadeGameScene {
    
    private func createObstacle() {
        let obstaclePosition = self.obstaclePosition()
        newObstacle(at: obstaclePosition)
    }
    
    private func obstaclePosition() -> CGPoint {
        let initialX: CGFloat = 25
        let finalX: CGFloat = self.frame.width - 25
        
        let positionX = CGFloat.random(in: initialX...finalX)
        let positionY = frame.height - 25
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func newObstacle(at position: CGPoint) {
        // Array di nomi di immagini per le auto
        var carImages: [String] = []
        
        for i in 1 ..< 5 {
            carImages.append("car\(i)")
        }
        
        // Seleziona casualmente un nome di immagine dalla lista
        if let randomCarImage = carImages.randomElement() {
            let newObstacle = SKSpriteNode(imageNamed: randomCarImage)
            let waitDuration = Double.random(in: 15...20)
            
            newObstacle.name = "car"
            newObstacle.xScale = 0.2
            newObstacle.yScale = 0.2
            newObstacle.position = position
            newObstacle.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
            newObstacle.physicsBody?.affectedByGravity = true
            newObstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
            newObstacle.physicsBody?.contactTestBitMask = PhysicsCategory.duck
            newObstacle.physicsBody?.collisionBitMask = PhysicsCategory.duck
            
            newObstacle.physicsBody?.velocity.dy = -300
            
            addChild(newObstacle)
            
            newObstacle.run(SKAction.sequence([
                SKAction.wait(forDuration: waitDuration),
                SKAction.removeFromParent()
            ]))
        }
    }
    
}

extension ArcadeGameScene : SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact){
        let collisionObject = contact.bodyB
        
        if collisionObject.categoryBitMask == PhysicsCategory.obstacle{
            finishGame()
        } else if collisionObject.categoryBitMask == PhysicsCategory.coin {
            collisionObject.node?.removeFromParent()
            registerScore()
            run(coinSound)
        }
    }
}
