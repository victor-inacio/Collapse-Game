import GameplayKit
import SpriteKit

class DoorComponent: GKComponent {
    override func didAddToEntity() {
        
        let triggerComponent = TriggerComponent {
            let node = self.entity!.component(ofType: SpriteComponent.self)!.node!
            
            if let userData = node.userData {
                let levelName = userData.value(forKey: "levelName") as! String
                
                if let level = SKScene(fileNamed: levelName) {
                    
                    let direction = self.getTransitionDirection()
                    let transition = SKTransition.push(with: direction, duration: 0.5)
                   
                    node.scene!.view?.presentScene(level, transition: transition)
                }
               
                
            }
        }

        self.entity?.addComponent(triggerComponent)
    }
    
    private func getTransitionDirection() -> SKTransitionDirection {
        
        var transition = SKTransitionDirection.left
        
        let node = self.entity!.component(ofType: SpriteComponent.self)!.node!
        
        let nodeScene = node.scene! as! BaseLevelScene
        
        if let sceneBoundaries = nodeScene.getBoundaries() {
            
            print(node.position.x, sceneBoundaries.position.x)
            
            if (node.position.x < sceneBoundaries.position.x) {
                transition = .right
            }
            
        }
        
        return transition
        
    }
}
