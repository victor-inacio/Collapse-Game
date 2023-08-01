//
//  Light.swift
//  MiniChallenge
//
//  Created by Gabriel Eirado on 01/08/23.
//

import Foundation
import SpriteKit
import GameplayKit

class Light{
    
    var playerLight: SKLightNode
    
    init(playerLight: SKLightNode) {
        self.playerLight = playerLight
        
       let playerLight = SKLightNode()
        playerLight.ambientColor = UIColor.darkGray
        playerLight.lightColor = .white
        
    }
}

