//
//  Player.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//

import SpriteKit
import GameplayKit

class Player{
    
    var playerNode: SKSpriteNode!
    var stateMachine: GKStateMachine?
    
    
    init(){
        
        let texture = SKTexture(imageNamed: "player")
        
        playerNode = SKSpriteNode(texture: texture, color: .red, size: texture.size())
        
        playerNode.zPosition = 1
        
        playerNode.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        playerNode.physicsBody?.collisionBitMask = physicsCategory.playerPhysics.rawValue
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.isDynamic = true
        
    }
    
    func applyMachine(){
                
        stateMachine = GKStateMachine(states: [
            PlayerIdle(), PlayerRun(), PlayerJump(), PlayerDash()
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
    func applyMovement(distanceX: CGFloat){
          
        //        print("movendo")
        playerNode.physicsBody!.velocity.dx = distanceX  * 4
        
        stateMachine?.enter(PlayerRun.self)
        //        print("\(distanceX)")
    }
    
    func jump(){

            print("tentei ")
        playerNode.physicsBody?.applyImpulse(CGVector(dx: playerNode.size.height * 2 , dy: playerNode.size.width * 0.5))

    }
//
    func Dash(direction: CGPoint){

       playerNode.physicsBody?.applyImpulse(CGVector(dx:direction.x , dy: direction.y  ))
        
        print(direction)
    }
}


class PlayerIdle: GKState{
    
    var player = Player()

    
    override func didEnter(from previousState: GKState?) {
        
        print("estou em Idle")
        
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





