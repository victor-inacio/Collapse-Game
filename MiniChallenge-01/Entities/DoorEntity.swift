import GameplayKit
import SpriteKit

// Entidade de porta
// Cria uma entidade e implementa os componentes necessários
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
