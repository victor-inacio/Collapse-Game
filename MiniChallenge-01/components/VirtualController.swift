//
//  VirtualController.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 13/07/23.
//

import SpriteKit

class ControllerJoystick: SKNode{
    
    let virtualControllerB: SKSpriteNode!
    let virtualControllerF: SKSpriteNode!
    
    override init(){
        
        let textureControllerB = SKTexture(imageNamed: "virtualControllerB")
        let textureControllerF = SKTexture(imageNamed: "virtualControllerF")
        
        virtualControllerB = SKSpriteNode(texture: textureControllerB, color: .white, size: textureControllerB.size())
        virtualControllerB.name = "controllerBack"
        virtualControllerB.zPosition = 5
        
        virtualControllerF = SKSpriteNode(texture: textureControllerF, color: .white, size: textureControllerF.size())
        virtualControllerF.name = "controllerFront"
        virtualControllerF.zPosition = 6
        
        super.init()
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

class DashButton: SKSpriteNode{
    init(){
        
        let texture = SKTexture(imageNamed: "dash")
        
        super.init(texture: texture, color: .red, size: texture.size())
        
        name = "dash"
        zPosition = 6
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
