//
//  ExplainScene3.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 24/07/23.
//

import SpriteKit

class ExplainScene3: ExplainScene1{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canSkip{
            if let scene = SKScene(fileNamed: "MainMenu") {
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
}
