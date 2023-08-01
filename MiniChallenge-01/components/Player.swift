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
    var canDash = true
    var dashDuration: CGFloat = 0.2
    var jumpVelocityFallOff: CGFloat = 35
    var pressingJump: Bool = false
    var jumpWasPressed: Bool = false
    var boosting = false
    var isGrounded = false
    var dashDirection: CGVector = .init(dx: 0, dy: 0)
    var canBoost = false
    var lastPlayerVelocity: CGVector = .init(dx: 0, dy: 0)
    var deathAudioPlayer = AudioManager(fileName: "water2")
        .setLoops(loops: 0).setVolume(volume: 0.1)
    
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
        deathAudioPlayer.play()
        
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
        
        let deadCount = userDefaults.integer(forKey: "commonDeadCount")
        userDefaults.set(deadCount + 1, forKey: "commonDeadCount")
    }
    
    func applyMachine(){
        
        stateMachine = GKStateMachine(states: [
            PlayerIdle(player: self),
            PlayerRun(player: self),
            PlayerJump(player: self),
            PlayerDash(player: self),
            PlayerDead(),
            PlayerFall(player: self),
            PlayerBoost(player: self)
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
    func checkFall() -> Bool {
        
        let currentVelocity = node.physicsBody?.velocity
        
        if doubleEqual(currentVelocity!.dy, 0) {
            return false
        }
        
        return currentVelocity!.dy < 0
    }
    
    func update() {
        
        if checkFall() {
            stateMachine.enter(PlayerFall.self)
        }
        
        if node.physicsBody?.velocity.dy == 0 && stateMachine.currentState is PlayerDash == false{
            isGrounded = true
            canDash = true
        }
        stateMachine.update(deltaTime: 0)
        
        lastPlayerVelocity = node.physicsBody!.velocity
        
        if stateMachine.currentState is PlayerDash == false{
          
            if (doubleEqual(node.physicsBody!.velocity.dy, 0) && doubleEqual(node.physicsBody!.velocity.dx, 0)){
                stateMachine.enter(PlayerIdle.self)
            } else if node.physicsBody?.velocity.dy == 0 {
                stateMachine.enter(PlayerRun.self)
            }
            
        }
        
        if (node.physicsBody?.velocity.dy ?? 0 < 100 || node.physicsBody?.velocity.dy ?? 0 > 100 && !pressingJump) && !isGrounded{
            if stateMachine.currentState is PlayerDash == false{
                node.physicsBody?.velocity.dy -= jumpVelocityFallOff
                stateMachine.enter(PlayerFall.self)
            }
        }
        if self.jumpWasPressed{
            self.stateMachine?.enter(PlayerBoost.self)
        }
    }
    
    func onJoystickChange(direction: CGPoint, angle: CGFloat) {
       
        velocityX = direction.x
        velocityY = direction.y
        
        if velocityX == 0 && velocityY == 0 {
            stateMachine.enter(PlayerIdle.self)
        } else if stateMachine.currentState is PlayerDash == false{
            stateMachine.enter(PlayerRun.self)
        }
        
        self.angle = angle
    
    }
    
    func applyMovement(distanceX: CGFloat, angle: CGFloat){
        if (stateMachine.currentState is PlayerDead) {
            return
        }
        
        if stateMachine.currentState is PlayerDash == false {
            
            if (!boosting) {
                node.physicsBody!.velocity.dx = distanceX * 5
            }
        }
        
        if angle > 1.50 || angle < -1.50{
            node.xScale = -1
        } else{
            node.xScale = 1
        }
    }
    
    func onJoystickJumpBtnTouchStart() {
        pressingJump = true
        
        if stateMachine.currentState is PlayerDash && isGrounded{
            jumpWasPressed = true
        }
        if pressingJump && stateMachine.currentState is PlayerDash == false && stateMachine.currentState is PlayerBoost == false{
            jump()
        }
    }
    
    func onJoystickJumpBtnTouchEnd() {
        pressingJump = false
    }
    
    
    func jump(){
        
        if isGrounded{
            
            isGrounded = false
            
            stateMachine.enter(PlayerJump.self)
          
            node.physicsBody?.applyImpulse(CGVector(dx: node.size.width , dy: node.size.height + node.size.height * 1.2 ))
            
        }
    }
    
    func onJoystickDashBtnTouch(direction: CGVector) {
        
        self.direction = direction
        
        if canDash && stateMachine.currentState is PlayerIdle == false{
            
            stateMachine.enter(PlayerDash.self)
            canBoost = true
            dash(direction: direction)
        }
    }
   
    
    func dash(direction: CGVector){

        node.physicsBody?.applyImpulse(direction * 200)
        
        node.texture = SKTexture(imageNamed: "Dash lado")
        
    }
    
    func shakeScreen() {
        
        let camera = node.scene!.camera!
        
        camera.run(.shake(initialPosition: camera.position, duration: 1, amplitudeX: 50, amplitudeY: 0))
        
    }
    
    func createTrail(trailCount: Int ,duration: CGFloat) {
        
        let eachTrailInterval = duration  / CGFloat(trailCount)
        
        
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
                    .fadeAlpha(to: 0, duration: duration),
                    .removeFromParent()
                ]))
            }),
            .wait(forDuration: eachTrailInterval)
        ]), count: trailCount))
    }
}


