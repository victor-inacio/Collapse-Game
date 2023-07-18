import GameplayKit
import SpriteKit

class FallenBlocksComponent: GKComponent {
    
    var canBeDestoyed = false
    
    override func didAddToEntity() {
        
        let node = self.entity!.component(ofType: SpriteComponent.self)!.node!
        let scene = node.scene!
        
        
        var nodeClone = node.copy() as! SKSpriteNode
        nodeClone.physicsBody = nil
        node.alpha = 0
        nodeClone.alpha = 1
        scene.addChild(nodeClone)
        
       
        
                
        let triggerComponent = TriggerComponent { otherNode in
            
            if (self.canBeDestoyed ) {
                
                if (otherNode?.name != "player") {
                    self.entity?.removeComponent(ofType: FallenBlocksComponent.self)
                    node.removeFromParent()
                }
                
                return
            } else {
                nodeClone.alpha = 1
                
                
                
                nodeClone.run(.sequence([
                    .shake(initialPosition: node.position, duration: 0.5),
                    SKAction.run {
                        node.physicsBody?.isDynamic = true
                        node.physicsBody?.affectedByGravity = true
                        nodeClone.removeFromParent()
                        node.alpha = 1
                        
                    }
                ]))
                self.canBeDestoyed = true
            }
            
            
        }
        self.entity?.addComponent(triggerComponent)
        node.physicsBody?.categoryBitMask = PhysicsCategory.fallen.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
    }
    
}

extension SKAction {
    class func shake(initialPosition:CGPoint, duration:Float, amplitudeX:Int = 10, amplitudeY:Int = 0) -> SKAction {
        let startingX = initialPosition.x
        let startingY = initialPosition.y
        let numberOfShakes = duration / 0.015
        var actionsArray:[SKAction] = []
        for index in 1...Int(numberOfShakes) {
            let newXPos = startingX + CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let newYPos = startingY + CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            actionsArray.append(SKAction.move(to: CGPointMake(newXPos, newYPos), duration: 0.015))
        }
        actionsArray.append(SKAction.move(to: initialPosition, duration: 0))
        return SKAction.sequence(actionsArray)
    }
}
