import GameplayKit
import SpriteKit

class FallenBlocksComponent: GKComponent {
    
    var canBeDestoyed = false
    var originalNode: SKSpriteNode!
    var originalNodeClone: SKSpriteNode!
    var nodeClone: SKSpriteNode!
    var scene: SKScene!
    var canReset = false
    
    
    override func didAddToEntity() {
        
        let node = self.entity!.component(ofType: SpriteComponent.self)!.node!
        node.alpha = 0
        originalNode = (node.copy() as! SKSpriteNode)
        
        scene = node.scene!
        
        let scene = node.scene!
        
        originalNodeClone = node.copy() as! SKSpriteNode
        originalNodeClone.physicsBody = nil
        originalNodeClone.alpha = 1
        
        nodeClone = originalNodeClone.copy() as! SKSpriteNode
        
        scene.addChild(nodeClone)
        
        let triggerComponent = TriggerComponent { otherNode in
            let node = self.entity!.component(ofType: SpriteComponent.self)!.node!
            if (self.canBeDestoyed) {
                if (!(otherNode?.entity is Player)) {
                    node.removeFromParent()
                    
                }
                
            } else {
                if let otherNode = otherNode {
                    let topPositionOfBlock = node.position.y + node.size.height / 2
                    let bottomPositionOfOtherNode = otherNode.position.y - otherNode.size.height / 2
                    
                    if (otherNode.entity is Player && otherNode.position.y >= topPositionOfBlock) {
                        self.nodeClone.run(.sequence([
                            .shake(initialPosition: node.position, duration: 0.5),
                            SKAction.run {
                                node.physicsBody?.isDynamic = true
                                node.physicsBody?.affectedByGravity = true
                                self.nodeClone.removeFromParent()
                                node.alpha = 1
                            }
                        ]))
                        self.canBeDestoyed = true
                        self.canReset = true
                    }
                }
            }
            
          
            
            
        }
        
        self.entity?.addComponent(triggerComponent)
        node.physicsBody?.categoryBitMask = PhysicsCategory.fallen.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
       
    }
    
    func reset() {
        if (canReset) {
            self.canBeDestoyed = false
            let copy = originalNode.copy() as! SKSpriteNode
            self.entity!.component(ofType: SpriteComponent.self)!.node = copy
            scene.addChild(copy)
            
            nodeClone = originalNodeClone.copy() as! SKSpriteNode
            
            scene.addChild(nodeClone)
            canReset = false
        }
        
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
