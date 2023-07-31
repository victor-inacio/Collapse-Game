import GameplayKit

class PlayerIdle: GKState{
    
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        
        player.node.run(.repeatForever(SKAction.animate(with: .init(format: "idle frame %@", frameCount: 1...4), timePerFrame: 0.5)), withKey: "idling")
       
        player.node.physicsBody?.velocity.dx = 0
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass != PlayerIdle.self
    }
    
    override func willExit(to nextState: GKState) {
        player.node.removeAction(forKey: "idling")
    }
    

}

class PlayerRun: GKState{
    
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        player.node.run(.repeatForever(SKAction.animate(with: .init(format: "run frame %@", frameCount: 1...4), timePerFrame: 0.1)), withKey: "run")
    }
    
    
    
    override func update(deltaTime seconds: TimeInterval) {
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass != PlayerRun.self
    }
    
    override func willExit(to nextState: GKState) {
        player.node.removeAction(forKey: "run")
    }
}


class PlayerJump: GKState{
    
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        player.node.run(SKAction.animate(with: .init(format: "jump frame %@", frameCount: 1...3), timePerFrame: 0.1), withKey: "jump")
    }
    
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if  stateClass == PlayerJump.self || stateClass == PlayerRun.self || stateClass == PlayerBoost.self {
            return false
        }
        
        return true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
    }
    
    override func willExit(to nextState: GKState) {
        player.node.removeAction(forKey: "jump")
    }
}

class PlayerDash: GKState{
    
    var player: Player!
    var audioPlayer = AudioManager(fileName: "dash2")
    var dashing: Bool = true
    
    init(player: Player){
        self.player = player
        audioPlayer.setLoops(loops: 0).setVolume(volume: 0.2)
    }
    
    
    
    
    override func didEnter(from previousState: GKState?) {
        
        if !player.canDash{
            return
        }
        
        audioPlayer.play()
        
        player.node.physicsBody?.velocity.dy = 0
        player.node.physicsBody?.affectedByGravity = false
        player.canDash = false
        player.canBoost = true
        
        player.node.run(.sequence([
            .wait(forDuration: player.dashDuration),
            .run {
                
                if !self.player.jumpWasPressed{
                    self.stateMachine?.enter(PlayerRun.self)
                }
                self.player.canBoost = false
                self.player.node.physicsBody?.affectedByGravity = true
                
            } ]))
        
        player.createTrail(trailCount: 8, duration: player.dashDuration)
        player.shakeScreen()
        
    }
    
    override func willExit(to nextState: GKState) {
        self.player.node.physicsBody?.affectedByGravity = true
        
        player.jumpWasPressed = false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if stateClass == PlayerRun.self{
            return true
        }
        
        if stateClass == PlayerBoost.self{
            return true
        }
        
        return false
    }
}

class PlayerFall: GKState {
    
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        player.node.run(.repeatForever(SKAction.animate(with: .init(format: "fall %@", frameCount: 1...3), timePerFrame: 0.1)), withKey: "fall")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass == PlayerJump.self {
            return false
        }
        
        return true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
        
    }
    
    override func willExit(to nextState: GKState) {
        player.node.removeAction(forKey: "fall")
    }
}


class PlayerBoost: GKState{
    
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        
            self.player.node.physicsBody?.velocity.dx /= 1.7
            self.player.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.player.node.size.height  * 1.4 ))
        player.createTrail(trailCount: 10, duration: 0.8)
            
        
    }
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if stateClass == PlayerIdle.self{
            return true
        }
        
        return false
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if self.player.node.physicsBody?.velocity.dy == 0{
            self.stateMachine?.enter(PlayerIdle.self)
        }
    }
    
}


class PlayerDead: GKState{
    
    
}
