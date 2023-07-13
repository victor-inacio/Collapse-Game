//
//  Ground.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 13/07/23.
//

import SpriteKit

class Ground: SKSpriteNode{
    
    init(){
        
        let texture = SKTexture(imageNamed: "ground")
        super.init(texture: texture, color: .red, size: texture.size())
        
        zPosition = 1
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
