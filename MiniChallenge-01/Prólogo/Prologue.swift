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
    var startAnimation: Bool = false
    var finishAnimation: Bool = false
    var shine = SKShapeNode()
    var bug: VisualBug!
    var scriptMove: SKSpriteNode!
    var pier: SKSpriteNode!
    var pierPhysicsBody: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        scriptMove = childNode(withName: "ScriptMove")! as? SKSpriteNode
        pier = childNode(withName: "Pier")! as? SKSpriteNode
        pierPhysicsBody = childNode(withName: "PierPhysicsBody")! as? SKSpriteNode
        
        bug = VisualBug()
        addVisualBug(nameOfTheAsset: "Bug")
        
        let controllerSize = virtualController.jumpButton?.size
        shine = SKShapeNode(ellipseOf: CGSize(width: (controllerSize?.width ?? 60) + 10 , height: (controllerSize?.height ?? 60) + 10))
        shine.lineWidth = 25
        cameraController.configHeight = 130
        virtualController.dashButton?.zPosition = -10
        virtualController.dashButton?.alpha = 0
        virtualController.jumpButton?.alpha = 0
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
            cameraController.configWidth = 400

            let wait = SKAction.wait(forDuration: 3)
            
            run(SKAction.sequence([wait, SKAction.run {
                self.addVisualBug(nameOfTheAsset: "Bug 1")
                self.run(SKAction.playSoundFileNamed("bugs", waitForCompletion: false))
            }, wait, SKAction.run {
                self.addVisualBug(nameOfTheAsset: "Bug 2")
                self.run(SKAction.playSoundFileNamed("bugs", waitForCompletion: false))
            }, wait, SKAction.run {
                self.addVisualBug(nameOfTheAsset: "Bug 3")
                self.pier.removeFromParent()
                self.pierPhysicsBody.removeFromParent()
                self.run(SKAction.playSoundFileNamed("bugs", waitForCompletion: false))
            }, SKAction.wait(forDuration: 0.3), SKAction.run {
                self.run(SKAction.playSoundFileNamed("bugs", waitForCompletion: false))
                self.run(SKAction.playSoundFileNamed("FinalBug", waitForCompletion: false))
                self.addBigVisualBug(nameOfTheAsset: "BigVisualBug")
                
            }, SKAction.wait(forDuration: 1.0),SKAction.run {
                for node in self.children{
                    if node.name == "Blind"{
                        let blind = SKAction.fadeAlpha(to: 1, duration: 1.5)
                        node.run(blind)
                        
                    }
                }
            }, SKAction.wait(forDuration: 3), SKAction.run {
                if let scene = SKScene(fileNamed: "ExplainScene2") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
                }
            }]))
            
        } else if !startAnimation && player.node.position.x > (childNode(withName: "InvisibleNode2")?.position.x ?? 500){
            startAnimation = true
        } else if finishAnimation{
            self.scene?.isPaused = false
        }
        
        
        
        
        if startJumpText && !finishJumpText{
            changeNodeAlpha(name: "LabelInvisible", alpha: 1)
            
            let controllerPosition = virtualController.jumpButton?.position
            shine.strokeColor = .systemPink
            shine.position = controllerPosition!
            shine.zPosition = virtualController.jumpButton!.zPosition - 1
            camera2.addChild(shine)
            virtualController.jumpButton?.alpha = 0.9
            
            run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.run {
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
    
    func changeNodeAlpha(name: String, alpha: Double){
        for node in self.children{
            if node.name == name{
                node.alpha = alpha
            }
        }
    }
}

extension SKScene{
    func blinkMode(shapeNode: SKShapeNode){
        let fadeInAction = SKAction.fadeAlpha(to: 0.1, duration: 0.5)
                let fadeOutAction = SKAction.fadeAlpha(to: 1.0, duration: 0.2)

                let blinkSequence = SKAction.sequence([fadeInAction, fadeOutAction])
                let blinkForever = SKAction.repeat(blinkSequence, count: 7)

        shapeNode.run(SKAction.sequence([blinkForever, SKAction.run {
            shapeNode.removeFromParent()
        }]) )
                
    }
    
    
}
