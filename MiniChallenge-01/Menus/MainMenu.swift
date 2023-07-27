//
//  MainMenu.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 23/07/23.
//

import SpriteKit

class MainMenu: SKScene{
    var newGameNode: SKSpriteNode!
    var cloud1: SKSpriteNode!
    var cloud2: SKSpriteNode!
    var cloud3: SKSpriteNode!
    var cloud4: SKSpriteNode!
    var cloud5: SKSpriteNode!
    var moon: SKSpriteNode!
    var limit: SKSpriteNode!
    var limit2: SKSpriteNode!
    var restart: SKSpriteNode!
    var restart2: SKSpriteNode!
    var rndNumber: Int!
    
    override func didMove(to view: SKView){
        cloud1 = childNode(withName: "Cloud 1")! as? SKSpriteNode
        cloud2 = childNode(withName: "Cloud 2")! as? SKSpriteNode
        cloud3 = childNode(withName: "Cloud 3")! as? SKSpriteNode
        cloud4 = childNode(withName: "Cloud 4")! as? SKSpriteNode
        cloud5 = childNode(withName: "Cloud 5")! as? SKSpriteNode
        moon = childNode(withName: "Moon")! as? SKSpriteNode
        limit = childNode(withName: "Limit")! as? SKSpriteNode
        limit2 = childNode(withName: "Limit 2")! as? SKSpriteNode
        restart = childNode(withName: "Restart")! as? SKSpriteNode
        restart2 = childNode(withName: "Restart 2")! as? SKSpriteNode
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
            if let scene = SKScene(fileNamed: "Phase2") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 3))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        cloud1!.position.x += 0.15
        cloud2!.position.x += 0.1
        cloud3!.position.x += 0.2
        cloud4!.position.x += 0.05
        cloud5!.position.x += 0.13
        moon.position.y += 0.05
        
        if cloud1.position.x > limit.position.x{
            cloud1.position.x = restart.position.x
        } else if cloud2.position.x > limit.position.x{
            cloud2.position.x = restart.position.x
        } else if cloud3.position.x > limit.position.x{
            cloud3.position.x = restart.position.x
        }else if cloud4.position.x > limit.position.x{
            cloud4.position.x = restart.position.x
        } else if moon.position.y > limit2.position.y{
            moon.position.y = restart2.position.y
        }else if cloud5.position.y > limit.position.y{
            cloud5.position.y = restart.position.y
        }
    }
    
    
}
