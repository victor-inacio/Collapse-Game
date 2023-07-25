//
//  Player.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//

import SpriteKit
import GameplayKit

class Player: VirtualControllerTarget{
    
    var playerNode: SKSpriteNode!
    var stateMachine: GKStateMachine!
    var velocityX: CGFloat = 0
    var velocityY: CGFloat = 0
    var angle: CGFloat = 0
    var onGround = false
    var jumpVelocityFallOff: CGFloat = 35
    var pressingJump: Bool = false

    
    init(){
        
        let texture = SKTexture(imageNamed: "player")
        
        playerNode = SKSpriteNode(texture: texture, color: .red, size: texture.size())
        
        playerNode.zPosition = 1
        
        playerNode.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        playerNode.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
        playerNode.physicsBody?.contactTestBitMask = 2
        
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.isDynamic = true
        playerNode.physicsBody?.restitution = 0
        
    }
    
    func applyMachine(){
        
        stateMachine = GKStateMachine(states: [
            PlayerIdle(playerNode: playerNode), PlayerRun(playerNode: playerNode), PlayerJump(), PlayerDash(), PlayerGrounded(), PlayerDead()
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
    func update() {
        
        if stateMachine.currentState is PlayerDash == false {
            applyMovement(distanceX: velocityX, angle: angle)
        }
        
        if playerNode.physicsBody!.velocity.dy == 0 && stateMachine.currentState is PlayerDash == false {
            stateMachine.enter(PlayerGrounded.self)
        }
        
        if (playerNode.physicsBody?.velocity.dy ?? 0 < 50 || playerNode.physicsBody?.velocity.dy ?? 0 > 0 && !pressingJump) && stateMachine.currentState is PlayerDash == false {
            playerNode.physicsBody?.velocity.dy -= jumpVelocityFallOff
        }
        print(velocityY)
    }
    
    func onJoystickChange(direction: CGPoint, angle: CGFloat) {
        
        if stateMachine.currentState is PlayerDash == false{
            applyMovement(distanceX: direction.x, angle: angle)
        }
        
        velocityX = direction.x
        velocityY = direction.y
        self.angle = angle
        
        if stateMachine.currentState is PlayerDash == false{
            stateMachine?.enter(PlayerRun.self)
        }
        
        //        print("x: \(direction.x) y: \(direction.y)")x
        //        print(angle)
    }
    
    
    
    func applyMovement(distanceX: CGFloat, angle: CGFloat){
        
        if stateMachine.currentState is PlayerDash == false{
            
            
            playerNode.physicsBody!.velocity.dx = distanceX * 7
        }
        
        if angle > 1.50 || angle < -1.50{
            playerNode.xScale = -1
        } else{
            playerNode.xScale = 1
        }
    }
    
    
    func onJoystickJumpBtnTouch(pressingJump: Bool) {
        
        self.pressingJump = pressingJump
        
        if stateMachine.currentState is PlayerDash == false && pressingJump{
            jump()
        }
        
    }
    
    func jump(){
        
        if stateMachine.currentState is PlayerGrounded || stateMachine.currentState is PlayerRun && playerNode.physicsBody?.velocity.dy == 0{
            
            playerNode.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: playerNode.size.height + playerNode.size.height / 4))
            
            stateMachine?.enter(PlayerJump.self)
            
        }
    }
    
    func onJoystickDashBtnTouch(direction: CGVector) {
        
        dash(direction: direction)
        
        stateMachine?.enter(PlayerDash.self)
        
    }
    
    func dash(direction: CGVector){
        
            self.playerNode.physicsBody?.affectedByGravity = false
            
            playerNode.physicsBody?.applyImpulse(CGVector(dx: direction.dx * 100 , dy: direction.dy * 100 ))
            
        
        if stateMachine.currentState is PlayerGrounded || stateMachine.currentState is PlayerRun && playerNode.physicsBody?.velocity.dy == 0 {
            
            self.playerNode.run(.sequence([.wait(forDuration: 0.2), .run{
                self.stateMachine?.enter(PlayerIdle.self)
                self.playerNode.physicsBody?.affectedByGravity = true
                
            }]))
        } else {
            
            self.playerNode.run(.sequence([.wait(forDuration: 0.25), .run{
                self.stateMachine?.enter(PlayerIdle.self)
                self.playerNode.physicsBody?.affectedByGravity = true
            }]))
            
            if playerNode.physicsBody?.velocity.dy == 0{
                playerNode.removeAllActions()
            }
        }
    }
}

class PlayerIdle: GKState {
    
    public var playerNode: SKSpriteNode
    
    init (playerNode: SKSpriteNode){
        self.playerNode = playerNode
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
       playerNode.run(.repeatForever(.animate(with: .init(format: "idle frame %@", frameCount: 1...4), timePerFrame: 0.4)))
    }
}

class PlayerRun: GKState{
    
    public var playerNode: SKSpriteNode
    
    init (playerNode: SKSpriteNode){
        self.playerNode = playerNode
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
   
    }
}

class PlayerJump: GKState{
    
    override func didEnter(from previousState: GKState?) {
        
    }
}

class PlayerDash: GKState{
    
    override func didEnter(from previousState: GKState?) {
      
    }
    
}

class PlayerGrounded: GKState{
    
    override func didEnter(from previousState: GKState?) {
    
        
    }
}


class PlayerDead: GKState {
    
    override func didEnter(from previousState: GKState?) {
    
    }
}
