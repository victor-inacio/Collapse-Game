import GameplayKit
import SpriteKit

class KillerCollisionComponent: GKComponent {
    
    override func didAddToEntity() {
        let trigger = TriggerComponent { otherNode in
                    
            if let entity = otherNode?.entity as? Player {
//                entity.die()
            }
                    
        }
        
        self.entity?.addComponent(trigger)
}
    
}
