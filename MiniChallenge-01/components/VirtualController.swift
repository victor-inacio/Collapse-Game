//
//  VirtualController.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 13/07/23.
//

import SpriteKit

class ControllerBack: SKSpriteNode{
    
    init(){
        
        let texture = SKTexture(imageNamed: "virtualControllerB")
        
        super.init(texture: texture, color: .red, size: texture.size())
        
        
        name = "controllerBack"
        zPosition = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ControllerFront: SKSpriteNode{
    
    init(){
        
        let texture = SKTexture(imageNamed: "virtualControllerF")
        
        super.init(texture: texture, color: .red, size: texture.size())
        
        name = "controllerFront"
        zPosition = 6
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JumpButton: SKSpriteNode{
    
    init(){
        
        let texture = SKTexture(imageNamed: "jump")
        
        super.init(texture: texture, color: .red, size: texture.size())
        
        name = "jump"
        zPosition = 6
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
