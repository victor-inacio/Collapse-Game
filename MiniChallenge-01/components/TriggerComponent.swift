import SpriteKit
import GameplayKit


class TriggerComponent: GKComponent {
    
    var callback: (_ otherNode: SKSpriteNode?) -> Void
    
    init(callback: @escaping (_ otherNode: SKSpriteNode?) -> Void) {
        self.callback = callback
        super.init()
    }
    
    override func didAddToEntity() {
        
        if let node = entity?.component(ofType: SpriteComponent.self)?.node {
    
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            
            var physicsBody = node.physicsBody
            
            if ((physicsBody == nil)) {
                physicsBody = SKPhysicsBody(rectangleOf: node.size)
                
                physicsBody?.isDynamic = false
                physicsBody?.affectedByGravity = false
                physicsBody?.allowsRotation = false
            }
            
            physicsBody?.categoryBitMask = 0
            physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
            physicsBody?.collisionBitMask = 0
           
            node.physicsBody = physicsBody
    
        }
    }
    
    
    required init?(coder: NSCoder) {
       fatalError("erwer")
    }
    
}
