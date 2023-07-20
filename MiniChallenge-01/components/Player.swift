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
    var angle: CGFloat = 0
    var onGround = false
    
    init(){
        
        let texture = SKTexture(imageNamed: "Frame 1 Personagem")

        let node = SKSpriteNode(texture: texture, color: .red, size: texture.size())
        
        node.zPosition = 1
        
        node.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
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
            node.physicsBody!.velocity.dx = distanceX  * 4
        }
        
        if angle > 1.51 || angle < -1.51{
            node.xScale = -1
        } else{
            node.xScale = 1
        }
    }
    
    func update() {
        
        if stateMachine.currentState is PlayerDash == false{
            applyMovement(distanceX: velocityX, angle: angle)
        }
        

        if node.physicsBody!.velocity.dy == 0 && stateMachine.currentState is PlayerDash == false {
           
            stateMachine.enter(PlayerGrounded.self)        }
    }
    
    func onJoystickJumpBtnTouch() {
     
            
        if stateMachine.currentState is PlayerDash == false{
            jump()
        }
    }
    
    func jump(){
        
        if stateMachine.currentState is PlayerGrounded {
            
            node.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: node.size.height * 1))
            
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
            
            node.physicsBody?.applyImpulse(CGVector(dx: direction.dx * 60 , dy: direction.dy * 100 ))
            
        }
        
        self.node.run(.sequence([.wait(forDuration: 0.5), .run{
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
    
    
    
    override func didEnter(from previousState: GKState?) {
        
//                print("run")
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        
        
    }
}

class PlayerJump: GKState{
    
    override func didEnter(from previousState: GKState?) {
        
    
        
    }
}

class PlayerDash: GKState{
    
    override func didEnter(from previousState: GKState?) {
    
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
        
//
        
    }
    
}
