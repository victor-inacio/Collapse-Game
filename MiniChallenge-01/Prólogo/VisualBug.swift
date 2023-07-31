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
        node.zPosition = 1.3
        
        node.run(.repeatForever(.repeatForever(.animate(with: .init(format: "VisualBug %@", frameCount: 1...3), timePerFrame: 0.2))))
        
    }
    
}

class BigVisualBug{
    let node: SKSpriteNode!
    
    init(){
        let bugTexture = SKTexture(imageNamed: "BigVisualBug 1")
        
        node = SKSpriteNode(texture: bugTexture)
        
        node.run(.repeatForever(.repeatForever(.animate(with: .init(format: "BigVisualBug %@", frameCount: 1...3), timePerFrame: 0.15))))
        
    }
}

extension SKScene{
    func addVisualBug(nameOfTheAsset: String){
        for node in self.children {
            if (node.name == nameOfTheAsset){
                
                let bug = VisualBug()
                bug.node.scale(to: CGSize(width: 64, height: 64))
                bug.node.position = CGPoint(x: node.position.x, y: node.position.y)
                
                if (nameOfTheAsset == "Bug 1*") || (nameOfTheAsset == "Bug 2*") || (nameOfTheAsset == "Bug 3*") || (nameOfTheAsset == "Bug 4*"){
                    bug.node.zPosition = -10
                }
                
                node.removeFromParent()
                self.addChild(bug.node)
            }
        }
    }
    
    func addBigVisualBug(nameOfTheAsset: String){
        for node in self.children {
            if (node.name == nameOfTheAsset){
                
                let bug = BigVisualBug()
                bug.node.scale(to: CGSize(width: 256, height: 192))
                bug.node.position = CGPoint(x: node.position.x, y: node.position.y)
                bug.node.zPosition = 12
                node.removeFromParent()
                self.addChild(bug.node)
            }
        }
    }
    
}


