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
    var angle: CGFloat = 0
    var onGround = false
    
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
            PlayerIdle(), PlayerRun(), PlayerJump(), PlayerDash(), PlayerGrounded(), PlayerDead()
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
    func onJoystickChange(direction: CGPoint, angle: CGFloat) {
        
        if stateMachine.currentState is PlayerDash == false{
            applyMovement(distanceX: direction.x, angle: angle)
        }
        velocityX = direction.x
        self.angle = angle
        
        if direction.x != 0 && stateMachine.currentState is PlayerDash == false{
            stateMachine?.enter(PlayerRun.self)
        }
        
        //        print("x: \(direction.x) y: \(direction.y)")x
        //        print(angle)
    }
    
    
    
    func applyMovement(distanceX: CGFloat, angle: CGFloat){
        
        if stateMachine.currentState is PlayerDash == false{
            playerNode.physicsBody!.velocity.dx = distanceX  * 4
        }
        
        if angle > 1.51 || angle < -1.51{
            playerNode.xScale = -1
        } else{
            playerNode.xScale = 1
        }
    }
    
    func update() {
        
        if stateMachine.currentState is PlayerDash == false{
            applyMovement(distanceX: velocityX, angle: angle)
        }
        
        print(playerNode.physicsBody!.velocity.dy)
        
        if playerNode.physicsBody!.velocity.dy == 0 && stateMachine.currentState is PlayerDash == false {
           
            stateMachine.enter(PlayerGrounded.self)        }
    }
    
    func onJoystickJumpBtnTouch() {
     
            
        if stateMachine.currentState is PlayerDash == false{
            jump()
        }
    }
    
    func jump(){
        
        if stateMachine.currentState is PlayerGrounded {
            
            playerNode.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: playerNode.size.height / 2))
            
            stateMachine?.enter(PlayerJump.self)
            
        }
    }
    
    func onJoystickDashBtnTouch(direction: CGVector) {
        
        dash(direction: direction)
        
        print(direction)
        
        stateMachine?.enter(PlayerDash.self)
        
    }
    
    func dash(direction: CGVector){
        
        if stateMachine.currentState is PlayerDash == false{
            
            playerNode.physicsBody?.applyImpulse(CGVector(dx: direction.dx * 35 , dy: direction.dy * 35 ))
            
        }
        
        self.playerNode.run(.sequence([.wait(forDuration: 0.5), .run{
            self.stateMachine?.enter(PlayerIdle.self)
        }]))
    }
}

class PlayerIdle: GKState {
    
    override func didEnter(from previousState: GKState?) {
        
        //        print("idle")
    }
}

class PlayerRun: GKState{
    
    var isRunning = false
    
    override func didEnter(from previousState: GKState?) {
        
//                print("run")
        isRunning = true
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        
        
    }
}

class PlayerJump: GKState{
    
    override func didEnter(from previousState: GKState?) {
        
                print("jump")
        
    }
}

class PlayerDash: GKState{
    
    override func didEnter(from previousState: GKState?) {
        print("dash")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        switch stateClass{
            
        case is PlayerRun:
            
            return false
            
        case is PlayerGrounded:
            
            return false
            
        default:
            
            return true
        }
    }
    
    override func willExit(to nextState: GKState) {
        
    }
}

class PlayerGrounded: GKState{
    
    override func didEnter(from previousState: GKState?) {
        
//        print("onGround")
        
    }
}


class PlayerDead: GKState {
    
    override func didEnter(from previousState: GKState?) {
        
//        print("onGround")
        
    }
    
}
