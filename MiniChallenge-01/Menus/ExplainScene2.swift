//
//  ExplainScene3.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 23/07/23.
//

import SpriteKit

class ExplainScene2: ExplainScene1{
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canSkip{
            player.setVolume(volume: 0, interval: 3)
            nextLevel("Phase1", transition: SKTransition.fade(withDuration: 3))
        } else{
            removeAllActions()
            label1.alpha = 1
            label2.alpha = 1
            continueButton.alpha = 1
            canSkip = true
        }
    }
}
