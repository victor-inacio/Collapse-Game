import GameplayKit
import SpriteKit

class DoorComponent: GKComponent {
    override func didAddToEntity() {
        
        let triggerComponent = TriggerComponent { otherNode in
            let node = self.entity!.component(ofType: SpriteComponent.self)!.node!
            
            if let userData = node.userData {
                let levelName = userData.value(forKey: "levelName") as! String
                
                if let level = SKScene(fileNamed: levelName) {

                    
                    let transition = SKTransition.fade(withDuration: 2)
                    level.scaleMode = .aspectFill
                    node.scene!.view?.presentScene(level, transition: transition)
                }
               
                
            }
        }

        self.entity?.addComponent(triggerComponent)
    }
    
}
