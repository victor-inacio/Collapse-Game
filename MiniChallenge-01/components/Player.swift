//
//  Player.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//

import SpriteKit

class Player: SKSpriteNode{
 
    init(){
        
        let texture = SKTexture(imageNamed: "player")
        
        super.init(texture: texture, color: .red, size: texture.size())
        
        zPosition = 1
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.collisionBitMask = physicsCategory.playerPhysics.rawValue
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
