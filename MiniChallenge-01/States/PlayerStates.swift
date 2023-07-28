import GameplayKit

class PlayerState: GKState {
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
}

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
        
        if player.canBoost{
            if stateClass == PlayerIdle.self {
                return true
            } else {
                return false
            }
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
        
        player.node.run(.sequence([.wait(forDuration: 0.2), .run{
         
                self.stateMachine?.enter(PlayerRun.self)
                self.player.canBoost = false
                self.player.node.physicsBody?.affectedByGravity = true
        }]))

        player.createTrail()
        player.shakeScreen()
        
        }
    
    override func willExit(to nextState: GKState) {
        self.player.node.physicsBody?.affectedByGravity = true
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if stateClass == PlayerRun.self{
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
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
//        if stateClass == PlayerIdle.self{
//            return true
//        }
        
        return false
    }

}


class PlayerDead: GKState{
    

}
