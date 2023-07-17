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
    
    func onJoystickJumpBtnTouch() {
        jump()
    }
    
    func onJoystickDashBtnTouch(direction: CGVector) {
        dash(direction: direction)
    }
    
    func applyMovement(distanceX: CGFloat){
          
        //        print("movendo")
        playerNode.physicsBody!.velocity.dx = distanceX  * 4
        
        
        stateMachine?.enter(distanceX == 0 ? PlayerIdle.self :  PlayerRun.self)
    
        
        //        print("\(distanceX)")
    }
    
    func jump(){
        playerNode.physicsBody?.applyImpulse(CGVector(dx: playerNode.size.height * 2 , dy: playerNode.size.width * 0.5))
    }

    func dash(direction: CGVector){
       playerNode.physicsBody?.applyImpulse(direction)
    }
}

class PlayerIdle: GKState {
    
    var player = Player()

    
    override func didEnter(from previousState: GKState?) {
        
   
    }
    
    func move() {
        
    }
}

class PlayerRun: GKState{
    
//    var gameScene = PlataformGameScene()
    var isRunning = false
    
    override func didEnter(from previousState: GKState?) {
        isRunning = true
    }
}

class PlayerJump: GKState{
    
    var player = Player()

    override func didEnter(from previousState: GKState?) {
        
        
        
        player.playerNode.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 3 * 0.5))
        print("pulou")
        
    }
}

class PlayerDash: GKState{
    
    var player = Player()
    var virtualController: VirtualController!
    
}
