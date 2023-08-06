import SpriteKit
import GameplayKit

// Entidade da água. Mata o personagem ao ser tocada
class WaterEntity: NodeEntity {
    
    
    
    override init(node: SKSpriteNode) {
        
        super.init(node: node)
        
        let spriteComponent = SpriteComponent(node: node)
        let killerComponent = KillerCollisionComponent()
        
        
        addComponent(spriteComponent)
       
        addComponent(killerComponent)
        
        node.entity = self
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
}
