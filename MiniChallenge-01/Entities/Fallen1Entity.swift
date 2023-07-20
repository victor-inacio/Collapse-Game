import SpriteKit
import GameplayKit

class Fallen1Entity: NodeEntity {
    
    override init(node: SKSpriteNode) {
        super.init(node: node)
        
        addComponent(SpriteComponent(node: node))
        addComponent(FallenBlocksComponent())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
}
