//
//  DrowingAnimation.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 21/07/23.
//

import SpriteKit

class VisualBug{
    let node: SKSpriteNode!
    
    init(){
        let bugTexture = SKTexture(imageNamed: "VisualBug")
        
        node = SKSpriteNode(texture: bugTexture)
        
        node.run(.repeatForever(.repeatForever(.animate(with: .init(format: "VisualBug %@", frameCount: 1...3), timePerFrame: 0.3))))
        
    }
    
}

extension SKScene{
    func addVisualBug(nameOfTheAsset: String){
        for node in self.children {
            if (node.name == nameOfTheAsset){
                let bug = VisualBug()
                bug.node.scale(to: CGSize(width: 64, height: 64))
                bug.node.position = CGPoint(x: node.position.x, y: node.position.y)
                node.removeFromParent()
                self.addChild(bug.node)
            }
        }
    }
    
    
}


