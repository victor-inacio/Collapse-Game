import GameplayKit

class PlayerState: GKState {
    var player: Player!
    
    init(player: Player) {
        self.player = player
    }
}

class PlayerIdle: PlayerState {
    override func didEnter(from previousState: GKState?) {
        player.node.physicsBody?.velocity = .init(dx: 0, dy: 0)
    }
}

class PlayerRun: PlayerState{

    override func update(deltaTime seconds: TimeInterval) {
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
    }

}

class PlayerJump: PlayerState{
    override func didEnter(from previousState: GKState?) {
        if (player.canBoost) {
            player.boosting = true
            
            player.node.run(.sequence([
                .wait(forDuration: 0.5),
                .run {
                    self.player.boosting = false
                }
            ]))
        }
        
        player.node.physicsBody?.applyImpulse(CGVector(dx: 300 * CGFloat( signNum(num: player.node.xScale)) , dy: player.node.size.height + player.node.size.height * 1.2 ))
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
        
        if (player.node.physicsBody?.velocity.dy ?? 0 < 50 || player.node.physicsBody?.velocity.dy ?? 0 > 0 && !player.pressingJump){
            player.node.physicsBody?.velocity.dy -= player.jumpVelocityFallOff
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if (stateClass == PlayerRun.self) {
            return false
        }
        
        return true
        
    }
}

class PlayerDash: PlayerState{
    
    var dashing: Bool = true
    var canDash: Bool = true
    
    override func didEnter(from previousState: GKState?) {
        
        if (!canDash) {
            return
        }
        
        dashing = true
        player.node.physicsBody?.affectedByGravity = false
        
        player.dashDirection = player.direction
        
        player.createTrail()
        player.shakeScreen()
        player.canBoost = true
        
        let boostLifeTime = 0.1
        
        player.canDash = false
        
        player.node.physicsBody?.applyImpulse(player.dashDirection * 300)
            
        player.node.run(.sequence([
            .wait(forDuration: player.dashDuration),
            .run{
            
            self.player.node.physicsBody?.affectedByGravity = true
            self.dashing = false
            
            self.player.node.run(.sequence([
                
                .wait(forDuration: boostLifeTime),
                .run {
                    self.player.canBoost = false
                    
                    self.player.node.run(.sequence([
                        
                        .wait(forDuration: self.player.dashDuration),
                        .run {
                            self.canDash = true
                        }
                    ]))
                }
            ]))
            
        }]))
        
        canDash = false
        }
    
    override func willExit(to nextState: GKState) {
        self.player.node.physicsBody?.affectedByGravity = true
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return !dashing
    }
}

class PlayerFall: PlayerState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if (stateClass == PlayerJump.self) {
            return false
        }
        
        return true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
        
        if (player.node.physicsBody?.velocity.dy ?? 0 < 50 || player.node.physicsBody?.velocity.dy ?? 0 > 0 && !player.pressingJump){
            if (!player.isGrounded) {
                player.node.physicsBody?.velocity.dy -= player.jumpVelocityFallOff
            }

        }
    }
    
}

class PlayerDead: PlayerState {
    

}
