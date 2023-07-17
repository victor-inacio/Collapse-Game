import GameplayKit
import SpriteKit

class DoorEntity: GKEntity {
    
    init(node: SKSpriteNode) {
            
        super.init()
        
        addComponent(SpriteComponent(node: node))
        
        addComponent(DoorComponent())
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
