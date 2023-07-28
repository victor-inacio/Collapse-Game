import GameplayKit

class PlayerIdle: GKState{
    
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        
        player.node.physicsBody?.velocity = .init(dx: 0, dy: 0)
    }
}

class PlayerRun: GKState{
    
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
    }
    
}

class PlayerJump: GKState{
    
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        
        if stateClass == PlayerBoost.self{
            return false
        }
        
        return true
        
    }
}

class PlayerDash: GKState{
    
    var player: Player!
    
    init(player: Player){
        self.player = player
    }
    
    var dashing: Bool = true
    
    
    override func didEnter(from previousState: GKState?) {
        
        if !player.canDash{
            return
        }
        
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
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass == PlayerJump.self {
            return false
        }
        
        return true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
        
    }
}


class PlayerBoost: GKState{
    
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        
            self.player.node.physicsBody?.velocity.dx /= 1.5
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
