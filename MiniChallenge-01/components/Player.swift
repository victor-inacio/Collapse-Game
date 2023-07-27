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
    var boosting = false
    private let dashDuration: CGFloat = 0.2
    private var dashDirection: CGVector = .init(dx: 0, dy: 0)
    private var canBoost = false
    
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
    
    //    func die() {
    //
    //        if (stateMachine.currentState is PlayerDead) {
    //            return
    //        }
    //
    //        if let scene = node.scene as? BaseLevelScene {
    //            scene.resetLevel()
    //            let spawnPoint = scene.getSpawnPoint()
    //            let move = SKAction.move(to: spawnPoint, duration: 0)
    //            move.timingMode = .easeInEaseOut
    //
    //            stateMachine.enter(PlayerDead.self)
    //            node.run(.sequence([
    //                move,
    //                .run {
    //                    self.node.physicsBody?.velocity.dx = 0
    //                    self.node.physicsBody?.velocity.dy = 0
    //                }
    //
    //            ]))
    //        }
    //    }
    
    func applyMachine(){
        
        stateMachine = GKStateMachine(states: [
            PlayerIdle(playerNode: node), PlayerRun(playerNode: node), PlayerJump(playerNode: node), PlayerDash(), PlayerGrounded(canDash: canDash), PlayerDead()
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
    func update() {
        
        if stateMachine.currentState is PlayerDash == false {
            applyMovement(distanceX: velocityX, angle: angle)
        }
        if node.physicsBody!.velocity.dy == 0 {
            stateMachine.enter(PlayerGrounded.self)
        }
        
        if (node.physicsBody?.velocity.dy ?? 0 < 50 || node.physicsBody?.velocity.dy ?? 0 > 0 && !pressingJump) && stateMachine.currentState is PlayerDash == false {
            node.physicsBody?.velocity.dy -= jumpVelocityFallOff
        }
        
        if node.physicsBody?.velocity.dx == 0 && node.physicsBody?.velocity.dy == 0{
            stateMachine.enter(PlayerIdle.self)
        }
        
        if stateMachine.currentState is PlayerGrounded{
            canDash = true
        }
        print(dashDirection)
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
        
        if stateMachine.currentState is PlayerDash == false {
            
            if (!boosting) {
                node.physicsBody!.velocity.dx = distanceX * 4
            }
        } else {
            
        }
        
        if angle > 1.50 || angle < -1.50{
            node.xScale = -1
        } else{
            node.xScale = 1
        }
    }
    
    func onJoystickJumpBtnTouchStart() {
        
        
        pressingJump = true
        
        if pressingJump{
            jump()
        }
        
    }
    
    func onJoystickJumpBtnTouchEnd() {
        pressingJump = false
    }
    
    
    func jump(){
        
        
        if stateMachine.currentState is PlayerGrounded || stateMachine.currentState is PlayerRun && node.physicsBody?.velocity.dy == 0{
            
            if (canBoost) {
                boosting = true
                
                node.run(.sequence([
                    .wait(forDuration: 0.5),
                    .run {
                        self.boosting = false
                    }
                ]))
            }
            
            print(node.xScale)
            
            
            node.physicsBody?.applyImpulse(CGVector(dx: 300 * CGFloat( signNum(num: node.xScale)) , dy: node.size.height + node.size.height * 1.2 ))
            
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
    
    func shakeScreen() {
        
        let camera = node.scene!.camera!
        
        camera.run(.shake(initialPosition: camera.position, duration: 1, amplitudeX: 50, amplitudeY: 0))
        
    }
    
    func dash(direction: CGVector){
        
        
        self.node.physicsBody?.affectedByGravity = false
        
        dashDirection = direction
        
                node.physicsBody?.applyImpulse(CGVector(dx: dashDirection.dx * 100, dy: dashDirection.dy * 100))
        
        createTrail()
        shakeScreen()
        //        canBoost = true
        
        let boostLifeTime = 0.1
        
        canDash = false
        
        if stateMachine.currentState is PlayerGrounded || stateMachine.currentState is PlayerRun && node.physicsBody?.velocity.dy == 0 {
            
            self.node.run(.sequence([.wait(forDuration: dashDuration), .run{
                self.stateMachine?.enter(PlayerIdle.self)
                self.node.physicsBody?.affectedByGravity = true
                
                self.node.run(.sequence([
                    
                    .wait(forDuration: boostLifeTime),
                    .run {
                        self.canBoost = false
                    }
                ]))
                
            }]))
        } else {
            
            self.node.run(.sequence([.wait(forDuration: 0.25), .run{
                self.stateMachine?.enter(PlayerIdle.self)
                self.node.physicsBody?.affectedByGravity = true
                
                self.node.run(.sequence([
                    
                    .wait(forDuration: boostLifeTime),
                    .run {
                        self.canBoost = false
                    }
                ]))
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
