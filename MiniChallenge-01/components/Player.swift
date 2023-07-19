//
//  Player.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//


import SpriteKit
import GameplayKit

class Player: NodeEntity ,VirtualControllerTarget{
    var stateMachine: GKStateMachine?
    var velocityX: CGFloat = 0
    var angle: CGFloat = 0
    
    init(){
        
        let texture = SKTexture(imageNamed: "player")
        
        let node = SKSpriteNode(texture: texture, color: .red, size: texture.size())
        
        node.zPosition = 1
        
        node.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        node.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        
        super.init(node: node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    func applyMachine(){
        
        stateMachine = GKStateMachine(states: [
            PlayerIdle(), PlayerRun(), PlayerJump(), PlayerDash()
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
    func onJoystickChange(direction: CGPoint, angle: CGFloat) {
    
        applyMovement(distanceX: direction.x, angle: angle)
    
        velocityX = direction.x
        self.angle = angle
        
        let xDirection: CGFloat = direction.x < 0 ? -1 : 1
        node.xScale = xDirection
        
    }

    func onJoystickJumpBtnTouch() {
        jump()
    }
    
    func onJoystickDashBtnTouch(direction: CGVector) {
        dash(direction: direction)
    }
    
    func applyMovement(distanceX: CGFloat, angle: CGFloat){
        
        node.physicsBody!.velocity.dx = distanceX  * 4
        
            
        if angle > 1.51 || angle < -1.51{

            node.xScale = -1

        } else{
            
            node.xScale = 1
            
        }
        
        
        
        if distanceX != 0{
            
            stateMachine?.enter(PlayerRun.self)
        }
    }
    
    func update() {
        applyMovement(distanceX: velocityX, angle: angle)
    }
    
    func jump(){
        
        node.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: node.size.height / 2))
        
        stateMachine?.enter(PlayerJump.self)
    }
    //
    func dash(direction: CGVector){
        
        node.physicsBody?.applyImpulse(CGVector(dx: direction.dx * 50 , dy: direction.dy * 50 ))
        
        stateMachine?.enter(PlayerDash.self)
        
//        print(direction)
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
        
//        print("Estou correndo")
        
        isRunning = true
        
    }
}

class PlayerJump: GKState{
    
    var player = Player()
    var onAir = false
    
    override func didEnter(from previousState: GKState?) {
        

        onAir = true
    }
}

class PlayerDash: GKState{
    
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func willExit(to nextState: GKState) {
       
    }
}
