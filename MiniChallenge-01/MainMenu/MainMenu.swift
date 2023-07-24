//
//  MainMenu.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 23/07/23.
//

import SpriteKit

class MainMenu: SKScene{
    var newGameNode: SKSpriteNode!
    
    override func didMove(to view: SKView){
        newGameNode = self.childNode(withName: "New Game")! as? SKSpriteNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if newGameNode.contains(touchLocation){
            newGameNode.alpha = 0.5
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        newGameNode.alpha = 0.9
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if newGameNode.contains(touchLocation){
            if let scene = SKScene(fileNamed: "ExplainScene1") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 3))
            }
        }
    }
    
    
}
