//
//  Player.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//

import SpriteKit
import GameplayKit

class Player{
    
    var player: SKSpriteNode!
    var stateMachine: GKStateMachine?
    
    init(){
        
        let texture = SKTexture(imageNamed: "player")
        
        player = SKSpriteNode(texture: texture, color: .red, size: texture.size())
        
        player.zPosition = 1
        
        name = "Player"
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
        
    }
    
    func applyMachine(){
        
        stateMachine = GKStateMachine(states: [
            PlayerIdle(), PlayerRun(), PlayerJump(), PlayerDash()
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
}

class PlayerIdle: GKState{
    
    var player = Player()
    var virtualController: VirtualController!
    
    override func didEnter(from previousState: GKState?) {
        
//        virtualController.distanceX = 0
        print("Idle")
    }
}

class PlayerRun: GKState{
    
    var player = Player()
    var virtualController: VirtualController!
    
    override func didEnter(from previousState: GKState?) {
        
        player.player.physicsBody!.velocity.dx = virtualController.distanceX * 4
        print("entrou")

    }
}


class PlayerJump: GKState{
    
    var player = Player()
    //    var virtualController: VirtualController!
    
    override func didEnter(from previousState: GKState?) {
        
        player.player.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 3 * 0.5))
        print("pulou")
        
    }
    
}

class PlayerDash: GKState{
    
    var player = Player()
    var virtualController: VirtualController!
    
    override func didEnter(from previousState: GKState?) {
        
        
        player.player.physicsBody?.applyImpulse(CGVector(dx: virtualController.direction.x, dy: virtualController.direction.y ))
        
    }
}





