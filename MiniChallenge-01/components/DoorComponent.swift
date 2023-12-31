import GameplayKit
import SpriteKit

class DoorComponent: GKComponent {
    override func didAddToEntity() {
        
        let triggerComponent = TriggerComponent {
            let node = self.entity!.component(ofType: SpriteComponent.self)!.node!
            
            if let userData = node.userData {
                let levelName = userData.value(forKey: "levelName") as! String
                
                if let level = SKScene(fileNamed: levelName) {
                    let transition = SKTransition.push(with: .left, duration: 0.5)
                    

                    
                    node.scene!.view?.presentScene(level, transition: transition)
                }
               
                
            }
        }

        self.entity?.addComponent(triggerComponent)
    }
}
