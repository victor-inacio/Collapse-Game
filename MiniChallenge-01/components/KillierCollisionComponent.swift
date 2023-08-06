import GameplayKit
import SpriteKit

// Componente para ser implementado em sprites que matam o jogador ao encostar
class KillerCollisionComponent: GKComponent {
    
   
    
    override func didAddToEntity() {
        let trigger = TriggerComponent { otherNode in
                    
            if let entity = otherNode?.entity as? Player {
                entity.die()
            }
                    
        }
        
        self.entity?.addComponent(trigger)
}
    
}
