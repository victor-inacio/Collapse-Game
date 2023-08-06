import SpriteKit
import GameplayKit

// Entidade dos blocos que caem. Implementa o FallenBlocksComponent
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
