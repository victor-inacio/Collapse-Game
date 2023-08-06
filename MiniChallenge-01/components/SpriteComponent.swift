import GameplayKit
import SpriteKit

// Componente que coloca um SKSpriteNode em um GKEntity
class SpriteComponent: GKComponent {
    
    var node: SKSpriteNode!
    
    private var _node: SKSpriteNode {
        
        get {
            return self.node
        }
        
        set {
            self.node = newValue
        }
    }
    
    init(node: SKSpriteNode) {
        super.init()
        self._node = node
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    
}
