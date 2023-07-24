//
//  ExplainScene.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 23/07/23.
//

import SpriteKit

class ExplainScene1: SKScene{
    var canSkip: Bool = false
    var label1: SKLabelNode!
    var label2: SKLabelNode!
    var continueButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        label1 = childNode(withName: "Label1")! as? SKLabelNode
        label2 = childNode(withName: "Label2")! as? SKLabelNode
        continueButton = childNode(withName: "Continue")! as? SKSpriteNode
        
        blinkModeLabel(shapeNode: label1)
        run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.run {
            self.blinkModeLabel(shapeNode: self.label2)
        }]))
        run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.run {
            self.blinkModeSprite(shapeNode: self.continueButton)
            self.canSkip = true
        }]))
            
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canSkip{
            if let scene = SKScene(fileNamed: "PlataformGameScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.up, duration: 3))
            }
        } else{
            removeAllActions()
            label1.alpha = 1
            label2.alpha = 1
            continueButton.alpha = 1
            canSkip = true
        }
    }
    
    func blinkModeSprite(shapeNode: SKSpriteNode){
        let fadeInAction = SKAction.fadeAlpha(to: 0.1, duration: 0.5)
                let fadeOutAction = SKAction.fadeAlpha(to: 1.0, duration: 4)

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
