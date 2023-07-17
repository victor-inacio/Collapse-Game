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
    var stateMachine: GKStateMachine?
    
    init(){
        
        let texture = SKTexture(imageNamed: "player")
        
        playerNode = SKSpriteNode(texture: texture, color: .red, size: texture.size())
        
        playerNode.zPosition = 1
        
        playerNode.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        playerNode.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.isDynamic = true
        
    }
    
    func applyMachine(){
        
        stateMachine = GKStateMachine(states: [
            PlayerIdle(), PlayerRun(), PlayerJump(), PlayerDash()
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
    func onJoystickChange(direction: CGVector) {
        
        applyMovement(distanceX: direction.dx)
        
    }
    
    func applyMovement(distanceX: CGFloat){
        
        
        playerNode.physicsBody!.velocity.dx = distanceX  * 4
        
        if distanceX != 0{
            
            stateMachine?.enter(PlayerRun.self)
        }
    }
    
    func jump(){
        
        
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: playerNode.size.height / 2))
        
        stateMachine?.enter(PlayerJump.self)
    }
    //
    func dash(direction: CGVector){
        
        playerNode.physicsBody?.applyImpulse(CGVector(dx: direction.dx * 50 , dy: direction.dy * 50 ))
        
        stateMachine?.enter(PlayerDash.self)
        
        print(direction)
    }
    
}

class PlayerIdle: GKState {
    
    var player = Player()
    
    
    override func didEnter(from previousState: GKState?) {
        
        print("estou em Idle")
        
    }
    
    func move() {
        
    }
}

class PlayerRun: GKState{
    
    //    var gameScene = PlataformGameScene()
    var isRunning = false
    
    override func didEnter(from previousState: GKState?) {
        
//        print("Estou correndo")
        
        isRunning = true
        
    }
}

class PlayerJump: GKState{
    
    var player = Player()
    var onAir = false
    
    override func didEnter(from previousState: GKState?) {
        
        print("pulou")
        onAir = true
    }
}

class PlayerDash: GKState{
    
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func willExit(to nextState: GKState) {
       
    }
}
