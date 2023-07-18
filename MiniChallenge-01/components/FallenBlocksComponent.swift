import GameplayKit
import SpriteKit

class FallenBlocksComponent: GKComponent {
    
    var canBeDestoyed = false
    
    override func didAddToEntity() {
        let node = self.entity!.component(ofType: SpriteComponent.self)!.node!
        
        
        let triggerComponent = TriggerComponent {
            if (self.canBeDestoyed) {
                self.entity?.removeComponent(ofType: FallenBlocksComponent.self)
                node.removeFromParent()
                return
            }
            
            node.run(.sequence([
                .shake(initialPosition: node.position, duration: 0.5),
                SKAction.run {
                    node.physicsBody?.isDynamic = true
                    node.physicsBody?.affectedByGravity = true
                    self.canBeDestoyed = true
                }
            ]))
        }
        self.entity?.addComponent(triggerComponent)
        node.physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
    }
    
}

extension SKAction {
    class func shake(initialPosition:CGPoint, duration:Float, amplitudeX:Int = 12, amplitudeY:Int = 3) -> SKAction {
        let startingX = initialPosition.x
        let startingY = initialPosition.y
        let numberOfShakes = duration / 0.015
        var actionsArray:[SKAction] = []
        for index in 1...Int(numberOfShakes) {
            let newXPos = startingX + CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let newYPos = startingY + CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            actionsArray.append(SKAction.move(to: CGPointMake(newXPos, newYPos), duration: 0.015))
        }
        actionsArray.append(SKAction.move(to: initialPosition, duration: 0.015))
        return SKAction.sequence(actionsArray)
    }
}
