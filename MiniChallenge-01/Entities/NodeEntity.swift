import SpriteKit
import GameplayKit

class NodeEntity: GKEntity {
    
    var node: SKSpriteNode {
        get {
            return self.component(ofType: SpriteComponent.self)!.node
        }
        
        set {
            self.component(ofType: SpriteComponent.self)?.node = newValue
        }
    }
    
    init(node: SKSpriteNode) {
        super.init()
        let spriteComponent = SpriteComponent(node: node)
        addComponent(spriteComponent)
        spriteComponent.node.entity = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Erorr")
    }
}
