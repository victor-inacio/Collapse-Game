//
//  Prologue.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 21/07/23.
//

import SpriteKit

class Prologue: BaseLevelScene{
    var startJumpText = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        cameraController.configSize = 130
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Prologue Start animation
        if startAnimation && !finishAnimation{
            camera2.zPosition = -10
            camera2.alpha = 0
            self.isUserInteractionEnabled = false
            virtualController.movementReset(size: scene!.size)
            
            
            if let scene = SKScene(fileNamed: "Phase1") {
                scene.scaleMode = .aspectFill
                view?.presentScene(scene, transition: SKTransition.fade(withDuration: 3))
            }
            finishAnimation = true
            
        } else if !startAnimation && player.node.position.x > (childNode(withName: "InvisibleNode2")?.position.x ?? 500){
            startAnimation = true
        }
        
        if startJumpText{
            for node in self.children{
                if node.name == "LabelInvisible"{
                    node.alpha = 1
                }
            }
            
        } else if !startJumpText && player.node.position.x > (childNode(withName: "InvisibleNode")?.position.x ?? 500){
            startJumpText = true
        }
        
    }
    
}
