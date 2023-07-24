import GameplayKit
import SpriteKit

class ParallaxItemEntity: NodeEntity {
    override init(node: SKSpriteNode) {
        super.init(node: node)
            
        node.entity = self
    }

    required init?(coder: NSCoder) {
        fatalError("Error")
    }
}
