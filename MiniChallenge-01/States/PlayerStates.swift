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
        
//        if player.canBoost {
//            player.boosting = true
//
//            player.node.run(.sequence([
//                .wait(forDuration: 0.5),
//                .run {
//                    self.player.boosting = false
//                }
//            ]))
//        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if stateClass == PlayerRun.self {
            return false
        }
        
        return true
        
    }
}

class PlayerDash: GKState{
    
    var player: Player!
    var canDash: Bool
    
    init(player: Player, canDash: Bool) {
        self.player = player
        self.canDash = canDash
    }
    
    var dashing: Bool = true

    
    override func didEnter(from previousState: GKState?) {
        
        player.node.physicsBody?.affectedByGravity = false
        
        
        player.node.run(.sequence([.wait(forDuration: 0.5), .run{
            self.stateMachine?.enter(PlayerRun.self)
            self.player.node.physicsBody?.affectedByGravity = true
        }]))
        
        
//        if (!canDash) {
//            return
//        }
//
//        dashing = true
//
//        player.node.physicsBody?.affectedByGravity = false
//
//        player.dashDirection = player.direction
//
        player.createTrail()

        if player.stateMachine.currentState is PlayerIdle == false{
            player.shakeScreen()
        }
//
//        player.canBoost = true
//
//        let boostLifeTime = 0.1
//
//        player.canDash = false
//
////        player.node.run(.sequence([
////            .wait(forDuration: player.dashDuration),
////            .run{
////                self.player.stateMachine.enter(PlayerRun.self)
////        }]))
////        player.node.run(.sequence([
////            .wait(forDuration: player.dashDuration),
////            .run{
////
////            self.player.node.physicsBody?.affectedByGravity = true
////            self.dashing = false
////
////            self.player.node.run(.sequence([
////
////                .wait(forDuration: boostLifeTime),
////                .run {
////                    self.player.node.run(.sequence([
////
////                        .wait(forDuration: self.player.dashDuration),
////                        .run {
////                            self.canDash = true
////                        }
////                    ]))
////                }
////            ]))
////
////        }]))
//
//        canDash = false
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
        if (stateClass == PlayerJump.self) {
            return false
        }
        
        return true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
      
        player.applyMovement(distanceX: player.velocityX, angle: player.angle)

    }
    
}

class PlayerDead: GKState{
    

}
