//
//  FinalScene.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 24/07/23.
//

import SpriteKit

class FinalScene: BaseLevelScene{
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        cameraController.configHeight = 130
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if (childNode(withName: "FinalTrigger")?.position.x)! > player.node.position.x{
            if let scene = SKScene(fileNamed: "ExplainScene3") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 3))
            }
        }
    }
}
