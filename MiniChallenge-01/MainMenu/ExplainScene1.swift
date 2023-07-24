//
//  ExplainScene.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 23/07/23.
//

import SpriteKit

class ExplainScene1: SKScene{
    var canSkip: Bool = false
    
    
    override func didMove(to view: SKView) {
        for node in self.children{
            if node.name == "Label1"{
                blinkModeLabel(shapeNode: node as! SKLabelNode)
            } else if node.name == "Label2"{
                run(SKAction.sequence([SKAction.wait(forDuration: 5.5), SKAction.run {
                    self.blinkModeLabel(shapeNode: node as! SKLabelNode)
                }]))
            } else if node.name == "Continue"{
                run(SKAction.sequence([SKAction.wait(forDuration: 11), SKAction.run {
                    self.blinkModeSprite(shapeNode: node as! SKSpriteNode)
                    self.canSkip = true
                }]))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canSkip{
            if let scene = SKScene(fileNamed: "PlataformGameScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.up, duration: 3))
            }
        }
    }
    
    func blinkModeSprite(shapeNode: SKSpriteNode){
        let fadeInAction = SKAction.fadeAlpha(to: 0.1, duration: 0.5)
                let fadeOutAction = SKAction.fadeAlpha(to: 1.0, duration: 5)

                let blinkSequence = SKAction.sequence([fadeInAction, fadeOutAction])
                let blinkForever = SKAction.repeat(blinkSequence, count: 1)

                shapeNode.run(blinkForever)
    }
    
    func blinkModeLabel(shapeNode: SKLabelNode){
        let fadeInAction = SKAction.fadeAlpha(to: 0.1, duration: 0.5)
                let fadeOutAction = SKAction.fadeAlpha(to: 1.0, duration: 1)

                let blinkSequence = SKAction.sequence([fadeInAction, fadeOutAction])
                let blinkForever = SKAction.repeat(blinkSequence, count: 1)

        shapeNode.run(blinkForever)
                
    }
}
