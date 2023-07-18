import SpriteKit
import GameplayKit


class TriggerComponent: GKComponent {
    
    var callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
        super.init()
    }
    
    override func didAddToEntity() {
        if let node = entity?.component(ofType: SpriteComponent.self)?.node {
            print(node.position)
    
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            
            node.physicsBody?.isDynamic = false
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.allowsRotation = false
            
            node.physicsBody?.categoryBitMask = 0
            node.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
            node.physicsBody?.collisionBitMask = 0
           
    
        }
    }
    
    
    required init?(coder: NSCoder) {
       fatalError("erwer")
    }
    
}
