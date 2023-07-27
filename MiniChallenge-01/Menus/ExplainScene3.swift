//
//  ExplainScene3.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 24/07/23.
//

import SpriteKit

class ExplainScene3: ExplainScene1{
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setUserDefaults()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canSkip{
            nextLevel("MainMenu", direction: SKTransitionDirection.up)
            userDefaults.set(true, forKey: "winGame")
        } else{
            removeAllActions()
            label1.alpha = 1
            label2.alpha = 1
            continueButton.alpha = 1
            canSkip = true
        }
    }
}
