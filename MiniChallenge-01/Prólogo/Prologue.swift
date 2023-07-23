//
//  Prologue.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 21/07/23.
//

import SpriteKit

class Prologue: BaseLevelScene{
    var startJumpText = false
    var finishJumpText = false
    var shine = SKShapeNode()
    var bug: VisualBug!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        bug = VisualBug()
        addVisualBug(nameOfTheAsset: "Bug")
        addVisualBug(nameOfTheAsset: "Bug 1")
        addVisualBug(nameOfTheAsset: "Special Bug")
        
        let controllerSize = virtualController.jumpButton?.size
        shine = SKShapeNode(ellipseOf: CGSize(width: (controllerSize?.width ?? 60) + 10 , height: (controllerSize?.height ?? 60) + 10))
        shine.lineWidth = 7
        cameraController.configSize = 130
        virtualController.dashButton?.zPosition = -10
        virtualController.dashButton?.alpha = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Prologue Start animation
        if startAnimation && !finishAnimation{
            camera2.zPosition = -10
            camera2.alpha = 0
            self.isUserInteractionEnabled = false
            virtualController.movementReset(size: scene!.size)
            finishAnimation = true

            let wait = SKAction.wait(forDuration: 2)
            
            run(SKAction.sequence([wait,SKAction.playSoundFileNamed("bugs", waitForCompletion: false), wait, SKAction.run {
                self.changeNodeAlpha(name: "Bug 1")
            }, wait ,SKAction.playSoundFileNamed("bugs", waitForCompletion: false), wait, SKAction.run {
                self.changeNodeAlpha(name: "Special Bug")
                if let scene = SKScene(fileNamed: "Phase1") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 3))
                }
            }]))
            
            
            
            
            
        } else if !startAnimation && player.node.position.x > (childNode(withName: "InvisibleNode2")?.position.x ?? 500){
            startAnimation = true
        }
        
        
        
        
        if startJumpText && !finishJumpText{
            changeNodeAlpha(name: "LabelInvisible")
            
            let controllerPosition = virtualController.jumpButton?.position
            shine.position = controllerPosition!
            shine.zPosition = virtualController.jumpButton!.zPosition - 1
            camera2.addChild(shine)
            
            run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run {
                for node in self.children{
                    if node.name == "Block"{
                        node.removeFromParent()
                    }
                }
            }]))
            
            blinkMode(shapeNode: shine)
            
            finishJumpText = true
            
        } else if !startJumpText && player.node.position.x > (childNode(withName: "InvisibleNode")?.position.x ?? 500){
            startJumpText = true
        }
        
    }
    
    func changeNodeAlpha(name: String){
        for node in self.children{
            if node.name == name{
                node.alpha = 1
            }
        }
    }
}

extension SKScene{
    func blinkMode(shapeNode: SKShapeNode){
        let fadeInAction = SKAction.fadeAlpha(to: 0.1, duration: 0.5)
                let fadeOutAction = SKAction.fadeAlpha(to: 1.0, duration: 0.5)

                let blinkSequence = SKAction.sequence([fadeInAction, fadeOutAction])
                let blinkForever = SKAction.repeat(blinkSequence, count: 6)

        shapeNode.run(SKAction.sequence([blinkForever, SKAction.run {
            shapeNode.removeFromParent()
        }]) )
                
    }
    
    
}
