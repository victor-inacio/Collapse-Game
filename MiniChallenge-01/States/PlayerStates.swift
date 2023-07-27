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
}

class PlayerDash: PlayerState{
    
    
    
}


class PlayerDead: PlayerState {
    

}
