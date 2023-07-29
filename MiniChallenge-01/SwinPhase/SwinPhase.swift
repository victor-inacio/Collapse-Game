//
//  SwinPhase.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 24/07/23.
//

import SpriteKit

class SwinPhase: BaseLevelScene{
    var swinButton: SKSpriteNode!
    var isTouched = false
    var canBlind = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        shine = SKShapeNode(ellipseOf: CGSize(width: (virtualController.jumpButton?.size.width)! + 10 , height: (virtualController.jumpButton?.size.height)! + 10))
        shine.lineWidth = 25
        shine.strokeColor = .yellow
        shine.position = (virtualController.jumpButton?.position)!
        shine.zPosition = virtualController.jumpButton!.zPosition - 1
        camera2.addChild(shine)
        blinkMode(shapeNode: shine)
        
        cameraController.configHeight = 100
        
        swinButton = SKSpriteNode(imageNamed: "jump")
        camera2.addChild(swinButton)
        swinButton.position = (virtualController.jumpButton?.position)!
        swinButton.zPosition = (virtualController.jumpButton?.zPosition)!
        swinButton.alpha = 0.9
        
        
        virtualController.jumpButton?.alpha = 0
        virtualController.dashButton?.alpha = 0
        
        
        player.node.physicsBody?.linearDamping = 1
        
        
        parallax = Parallax(scene: self, items: [
            .init(fileName: "New Planet", velocityFactor: 0, zIndex: -5, offset: CGVector(dx: 0, dy: 450)),
            .init(fileName: "New planet 2", velocityFactor: -0.02, zIndex: -4, offset: CGVector(dx: 150, dy: 200)),
            .init(fileName: "New Planet 3", velocityFactor: 0.06, zIndex: -3, offset: CGVector(dx: -140, dy: 200)),
        ])
        
        for node in self.children{
            if (node.name == "WaterFake"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyWater(map: someTileMap, textureWidth: 64, tileMapProportion: 64)
                    someTileMap.removeFromParent()
                }
            }
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        super.update(currentTime)
        if player.node.position.y < (childNode(withName: "Limiting gravity")?.position.y)! && isTouched{
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 5)
        } else if  player.node.position.y > (childNode(withName: "Limiting gravity")?.position.y)!{
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -4)
            
        } else if player.node.position.y < ((childNode(withName: "Limiting gravity")?.position.y)!) + 10{
            player.node.physicsBody?.applyForce(CGVector(dx: 0, dy: 144))
        }
        
        if (childNode(withName: "LabelTrigger")?.position.x)! > player.node.position.x{
            childNode(withName: "Label1")?.alpha = 1
        }
        
        if (childNode(withName: "TriggerBlind")?.position.x)! > player.node.position.x{
            if let scene = SKScene(fileNamed: "FinalScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 4))
            }
        }
        parallax.update()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: camera2)
                
        if swinButton.contains(touchLocation){
            swinButton.alpha = 0.6
            isTouched = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        swinButton.alpha = 0.9
        isTouched = false

    }
    

}
