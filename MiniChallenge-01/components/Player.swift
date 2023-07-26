//
//  Player.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//


import SpriteKit
import GameplayKit

class Player: NodeEntity, VirtualControllerTarget{
    var stateMachine: GKStateMachine!
    var velocityX: CGFloat = 0
    var velocityY: CGFloat = 0
    var direction: CGVector!
    var angle: CGFloat = 0
    var canDash = false
    var jumpVelocityFallOff: CGFloat = 35
    var pressingJump: Bool = false
    
    init(){
        
        let texture = SKTexture(imageNamed: "player")
        
        let node = SKSpriteNode(texture: texture, color: .red, size: texture.size())
        
        node.zPosition = 1
        
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: texture.size().width, height: texture.size().height))
        node.physicsBody?.contactTestBitMask = PhysicsCategory.floor.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategory.floor.rawValue
        node.physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        node.physicsBody?.restitution = 0
        
        super.init(node: node)
        
        applyMachine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    func die() {
        
        if (stateMachine.currentState is PlayerDead) {
            return
        }
        
        if let scene = node.scene as? BaseLevelScene {
            scene.resetLevel()
            let spawnPoint = scene.getSpawnPoint()
            let move = SKAction.move(to: spawnPoint, duration: 0)
            move.timingMode = .easeInEaseOut
            
            stateMachine.enter(PlayerDead.self)
            node.run(.sequence([
                move,
                .run {
                    self.node.physicsBody?.velocity.dx = 0
                    self.node.physicsBody?.velocity.dy = 0
                }
                
            ]))
        }
    }
    
    func applyMachine(){
        
        stateMachine = GKStateMachine(states: [
            PlayerIdle(playerNode: playerNode), PlayerRun(playerNode: playerNode), PlayerJump(playerNode: playerNode), PlayerDash(), PlayerGrounded(canDash: canDash), PlayerDead()
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
   func update() {
        
       if stateMachine.currentState is PlayerDash == false {
           applyMovement(distanceX: velocityX, angle: angle)
       }

        if node.physicsBody!.velocity.dy == 0 && stateMachine.currentState is PlayerDash == false {
            stateMachine.enter(PlayerGrounded.self)
        }

        if (node.physicsBody?.velocity.dy ?? 0 < 50 || node.physicsBody?.velocity.dy ?? 0 > 0 && !pressingJump) && stateMachine.currentState is PlayerDash == false {
            node.physicsBody?.velocity.dy -= jumpVelocityFallOff
        }
        
        if playerNode.physicsBody?.velocity.dx == 0 && playerNode.physicsBody?.velocity.dy == 0{
            stateMachine.enter(PlayerIdle.self)
        }
        
        if stateMachine.currentState is PlayerGrounded{
            canDash = true
        }
        print(direction)
    }
    
    func onJoystickChange(direction: CGPoint, angle: CGFloat) {
        
        
        velocityX = direction.x
        velocityY = direction.y
        self.angle = angle
        
        if stateMachine.currentState is PlayerDash == false{
            stateMachine?.enter(PlayerRun.self)
        }
    }
    
    func applyMovement(distanceX: CGFloat, angle: CGFloat){
        if (stateMachine.currentState is PlayerDead) {
            return
        }
        
        if stateMachine.currentState is PlayerDash == false{
            
            playerNode.physicsBody!.velocity.dx = distanceX * 7
            
        }
        
        if angle > 1.50 || angle < -1.50{
            playerNode.xScale = -1
        } else{
            node.xScale = 1
        }
    }
    
    func onJoystickJumpBtnTouch(pressingJump: Bool) {
        
        self.pressingJump = pressingJump
        
        if pressingJump{
            jump()
        }
        
    }
    
    func jump(){
        
        if stateMachine.currentState is PlayerGrounded || stateMachine.currentState is PlayerRun && node.physicsBody?.velocity.dy == 0{
            
            playerNode.physicsBody?.applyImpulse(CGVector(dx: playerNode.size.height , dy: playerNode.size.height + playerNode.size.height / 4))
            
            stateMachine?.enter(PlayerJump.self)
            
        }
    }
    
    func onJoystickDashBtnTouch(direction: CGVector) {
        
        self.direction = direction
        
        if canDash{
            dash(direction: direction)
            
            stateMachine?.enter(PlayerDash.self)
        }
    }
    
    func dash(direction: CGVector){
        
        
        self.playerNode.physicsBody?.affectedByGravity = false
        playerNode.physicsBody?.applyImpulse(CGVector(dx: direction.dx * 100 , dy: direction.dy * 80 ))
        
        canDash = false
        
        if stateMachine.currentState is PlayerGrounded || stateMachine.currentState is PlayerRun && playerNode.physicsBody?.velocity.dy == 0 {
            
            self.playerNode.run(.sequence([.wait(forDuration: 0.25), .run{
                self.stateMachine?.enter(PlayerIdle.self)
                self.node.physicsBody?.affectedByGravity = true
                
            }]))
        } else {
            
            self.node.run(.sequence([.wait(forDuration: 0.25), .run{
                self.stateMachine?.enter(PlayerIdle.self)
                self.node.physicsBody?.affectedByGravity = true
            }]))
            
            
            
            if node.physicsBody?.velocity.dy == 0{
                node.removeAllActions()
            }
        }
    }
    
    func createTrail() {
        
        let trailCount = 10
        let eachTrailInterval = dashDuration / CGFloat(trailCount)
        
        
        node.run(.repeat(.sequence([
            .run({
                let shader = SKShader(fileNamed: "WhiteSpriteShader")
                let texture = self.node.texture
                
                let trailSprite = SKSpriteNode(texture: texture)
                trailSprite.position = self.node.position
                
                self.node.scene!.addChild(trailSprite)
                
                
                
                trailSprite.alpha = 0.5
                trailSprite.shader = shader
                
                trailSprite.run(.sequence([
                    .fadeAlpha(to: 0, duration: self.dashDuration),
                    .removeFromParent()
                ]))
            }),
            .wait(forDuration: eachTrailInterval)
        ]), count: trailCount))
        
    }
    
}

class PlayerIdle: GKState {
    
    public var playerNode: SKSpriteNode
    
    init (playerNode: SKSpriteNode){
        self.playerNode = playerNode
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
//        playerNode.run(.repeatForever(.animate(with: .init(format: "idle frame %@", frameCount: 1...4), timePerFrame: 0.4)))
    }
}

class PlayerRun: GKState{
    
    public var playerNode: SKSpriteNode
    
    init (playerNode: SKSpriteNode){
        self.playerNode = playerNode
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
//        playerNode.run(.repeatForever(.animate(with: .init(format: "run frame %@", frameCount: 1...4), timePerFrame: 0.4)))
    }
}

class PlayerJump: GKState{
    
    public var playerNode: SKSpriteNode
    
    init (playerNode: SKSpriteNode){
        self.playerNode = playerNode
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
//        playerNode.run(.repeatForever(.animate(with: .init(format: "jump frame %@", frameCount: 1...4), timePerFrame: 0.4)))
    }
}

class PlayerDash: GKState{
    
    override func didEnter(from previousState: GKState?) {
        
    }
    
}

class PlayerGrounded: GKState{
    
    var canDash = false
    
    init (canDash: Bool){
        self.canDash = canDash
        super.init()
    }
    override func didEnter(from previousState: GKState?) {
        
        canDash = true
        
    }
    
    override func willExit(to nextState: GKState) {
        
        canDash = false
        
    }
}


class PlayerDead: GKState {
    
    override func didEnter(from previousState: GKState?) {
        
    }
}
