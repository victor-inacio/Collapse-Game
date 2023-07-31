//
//  MainMenu.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 23/07/23.
//

import SpriteKit
import AVFAudio

class MainMenu: SKScene{
    var newGameNode: SKSpriteNode!
    var continueButton: SKSpriteNode!
    var cloud1: SKSpriteNode!
    var cloud2: SKSpriteNode!
    var cloud3: SKSpriteNode!
    var cloud4: SKSpriteNode!
    var cloud5: SKSpriteNode!
    var moon: SKSpriteNode!
    var limit: SKSpriteNode!
    var limit2: SKSpriteNode!
    var restart: SKSpriteNode!
    var restart2: SKSpriteNode!
    var rndNumber: Int!
    var dieLabel: SKLabelNode!
    var canContinue: Bool = false
    
    var player: AVAudioPlayer!
    
    override func didMove(to view: SKView){
        
        
        cloud1 = childNode(withName: "Cloud 1")! as? SKSpriteNode
        cloud2 = childNode(withName: "Cloud 2")! as? SKSpriteNode
        cloud3 = childNode(withName: "Cloud 3")! as? SKSpriteNode
        cloud4 = childNode(withName: "Cloud 4")! as? SKSpriteNode
        cloud5 = childNode(withName: "Cloud 5")! as? SKSpriteNode
        moon = childNode(withName: "Moon")! as? SKSpriteNode
        limit = childNode(withName: "Limit")! as? SKSpriteNode
        limit2 = childNode(withName: "Limit 2")! as? SKSpriteNode
        restart = childNode(withName: "Restart")! as? SKSpriteNode
        restart2 = childNode(withName: "Restart 2")! as? SKSpriteNode
        newGameNode = self.childNode(withName: "New Game")! as? SKSpriteNode
        continueButton = self.childNode(withName: "Continue")! as? SKSpriteNode
        dieLabel = childNode(withName: "HighScore")! as? SKLabelNode
        
        
        let fadeInAction = SKAction.fadeAlpha(to: 0.1, duration: 0.2)
        let fadeOutAction = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
        let blinkSequence = SKAction.sequence([fadeInAction, fadeOutAction])
        let blinkForever = SKAction.repeat(blinkSequence, count: 7)
        dieLabel.run(blinkForever)
        
        print(winGame)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        guard let soundFileURL = Bundle.main.url(forResource: "intro", withExtension: "mp3") else {
            print("Arquivo de som não encontrado.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundFileURL)
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
        } catch {
            print("Erro ao reproduzir o som: (error.localizedDescription)")
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if newGameNode.contains(touchLocation){
            newGameNode.alpha = 0.5
            print(canContinue)
        }
        
        if continueButton.contains(touchLocation) && canContinue{
            continueButton.alpha = 0.5
            print("Cheguei")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        newGameNode.alpha = 0.9
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if canContinue{
            continueButton.alpha = 0.9
        }
        
        if newGameNode.contains(touchLocation){
            userDefaults.set(0, forKey: "commonDeadCount")
            run(SKAction.playSoundFileNamed("Touch", waitForCompletion: false))
            
            nextLevel("ExplainScene1", direction: SKTransitionDirection.down)
        }
        
        if continueButton.contains(touchLocation) && canContinue{
            run(SKAction.playSoundFileNamed("TouchContinued", waitForCompletion: false))
            nextLevel(levelName ?? "ExplainScene1", transition: SKTransition.fade(with: .white, duration: 1.4))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if !winGame{
            userDefaults.set(-1, forKey: "minDeadCount")
        }
//        print(winGame)
        
        winGame = userDefaults.bool(forKey: "winGame")
        commonDeadCount = userDefaults.integer(forKey: "commonDeadCount")
//        print(commonDeadCount)
        minDeadCount = userDefaults.integer(forKey: "minDeadCount")
//        print("min: \(minDeadCount)")
        levelName = userDefaults.string(forKey: "highLevelName")
        
        if levelName != nil{
            canContinue = true
        }
        
        if minDeadCount == -1 && !canContinue{
            let deadNumber = userDefaults.integer(forKey: "commonDeadCount")
            userDefaults.set(deadNumber, forKey: "minDeadCount")
        } else if commonDeadCount < minDeadCount && !canContinue{
            let deadNumber = userDefaults.integer(forKey: "commonDeadCount")
            userDefaults.set(deadNumber, forKey: "minDeadCount")
        }
        
        
        
        dieLabel.text = "Menor número de mortes: \((winGame) ? String(minDeadCount) : "---" )"
        cloud1!.position.x += 0.15
        cloud2!.position.x += 0.1
        cloud3!.position.x += 0.2
        cloud4!.position.x += 0.05
        cloud5!.position.x += 0.13
        moon.position.y += 0.05
        
        if cloud1.position.x > limit.position.x{
            cloud1.position.x = restart.position.x
        } else if cloud2.position.x > limit.position.x{
            cloud2.position.x = restart.position.x
        } else if cloud3.position.x > limit.position.x{
            cloud3.position.x = restart.position.x
        }else if cloud4.position.x > limit.position.x{
            cloud4.position.x = restart.position.x
        } else if moon.position.y > limit2.position.y{
            moon.position.y = restart2.position.y
        }else if cloud5.position.y > limit.position.y{
            cloud5.position.y = restart.position.y
        }
    }
    
    
}

extension SKScene{
    func nextLevel(_ a: String, direction: SKTransitionDirection){
        if let scene = SKScene(fileNamed: a){
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: SKTransition.push(with: direction, duration: 3))
        }
    }
    
    func nextLevel(_ a: String, transition: SKTransition){
        if let scene = SKScene(fileNamed: a){
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: transition)
        }
    }
}
