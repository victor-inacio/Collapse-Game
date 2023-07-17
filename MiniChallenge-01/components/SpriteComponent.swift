import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
    
    var node: SKSpriteNode!
    
    init(node: SKSpriteNode) {
        super.init()
        self.node = node
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    
}
