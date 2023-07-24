//
//  Phase1.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 17/07/23.
//

import Foundation
import SpriteKit
import GameplayKit

class Phase1: BaseLevelScene{
    var shine = SKShapeNode()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let controllerSize = virtualController.dashButton?.size
        let controllerPosition = virtualController.dashButton?.position
        shine = SKShapeNode(ellipseOf: CGSize(width: (controllerSize?.width ?? 60) + 10 , height: (controllerSize?.height ?? 60) + 10))
        shine.lineWidth = 18
        shine.strokeColor = .blue
        shine.position = controllerPosition!
        shine.zPosition = virtualController.dashButton!.zPosition - 1
        camera2.addChild(shine)
        blinkMode(shapeNode: shine)
        
        for node in self.children {
            if (node.name == "InvisibleLabel") || (node.name == "SuportNode"){
                let action = SKAction.run {
                    node.removeFromParent()
                }
                let sequence = SKAction.sequence([SKAction.wait(forDuration: 5), action])
                run(sequence)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if self.player.node.position.x > (childNode(withName: "InvisibleNode")?.position.x ?? 500){
            
        } else{
            
        }
    }
}
    
