//
//  VirtualController.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 13/07/23.
//

import SpriteKit
import GameplayKit

protocol VirtualControllerTarget {
    
    func onJoystickChange(direction: CGPoint, angle: CGFloat) -> Void
    func onJoystickJumpBtnTouchStart() -> Void
    func onJoystickJumpBtnTouchEnd() -> Void
    func onJoystickDashBtnTouch(direction: CGVector) -> Void
}

class VirtualController: SKNode{
    var jogoPausado: SKSpriteNode?
    var creditsButton: SKSpriteNode?
    var overlayShadow:SKSpriteNode?
    var overlayPause: SKSpriteNode?
    var isOverlay: Bool = false
    var pauseButton: SKSpriteNode?
    var pauseTouch: UITouch?
    var isAppInForeground: Bool = true
    var exitButton: SKSpriteNode?
    var soundButton: SKSpriteNode?
    var isSoundMuted: Bool = false {
        didSet {
            if isSoundMuted {
                soundButton?.texture = SKTexture(imageNamed: "soundOff")
                //Lógica de Desligar o som do Jogo aqui
            
            } else {
                soundButton?.texture = SKTexture(imageNamed: "soundOn")
                // Lógica de Ligar o som do Jogo aqui
            }
        }
    }
    var skull: SKSpriteNode?
    var deadCount: SKLabelNode?
    
    var virtualJoystickB: SKSpriteNode?
    var virtualJoystickF: SKSpriteNode?
    var jumpButton: SKSpriteNode?
    var dashButton: SKSpriteNode?
    var joystickTouch: UITouch?
    var jumpTouch: UITouch?
    var dashTouch: UITouch?
    var direction: CGVector = CGVector(dx: 0, dy: 0){
        didSet{
            self.target.onJoystickChange(direction: CGPoint(x: self.velocityX, y: self.velocityY), angle: joystickAngleRounded)
        }
    }
    var joystickAngleRounded: CGFloat = 0
    var velocityX: CGFloat = 0
    var velocityY: CGFloat = 0
    var distanceX: CGFloat = 0
    var distanceY: CGFloat = 0
    
    var joystickInUse: Bool = false

    var gameScene = BaseLevelScene()
    var target: VirtualControllerTarget!
    
    init(target: VirtualControllerTarget, scene: SKScene){
        super.init()
        isUserInteractionEnabled = true
        
        self.target = target
        
        // OVERLAY JOGO PAUSADO
        let textureJogoPausado = SKTexture(imageNamed: "jogopaused")
        jogoPausado = SKSpriteNode(texture: textureJogoPausado, color: .white, size: textureJogoPausado.size())
        jogoPausado?.name = "jogoPausado"
        jogoPausado?.zPosition = 10
        
        
        
        //OVERLAY CREDITS BUTTON
        
        let textureCreditsButton = SKTexture(imageNamed: "credits")
        creditsButton = SKSpriteNode(texture: textureCreditsButton, color: .white, size: textureCreditsButton.size())
        creditsButton?.name = "credit"
        creditsButton?.zPosition = 10
        creditsButton?.alpha = 0.3
        
        
        //OVERLAY SOUND BUTTON
        let textureSoundButton = SKTexture(imageNamed: "soundOn")
        soundButton = SKSpriteNode(texture: textureSoundButton, color: .white, size: textureSoundButton.size())
        
        soundButton?.name = "sound"
        soundButton?.zPosition = 10
        
        
        //OVERLAY EXIT BUTTON
        let textureExitButton = SKTexture(imageNamed: "exitButton")
        exitButton = SKSpriteNode(texture: textureExitButton, color: .white, size: textureExitButton.size())
        
        exitButton?.name = "exit"
        exitButton?.zPosition = 10
        
        //OVERLAY SHADOW
        let textureoverlayReturnButton = SKTexture(imageNamed: "overlayReturn")
        
        overlayShadow = SKSpriteNode(texture: textureoverlayReturnButton, size: textureoverlayReturnButton.size())
        
        overlayShadow?.name = "returnOverlay"
        overlayShadow?.zPosition = -1
        
        //OVERLAY PAUSE
        let textureOverlayPause = SKTexture(imageNamed: "overlayPause")
        
        overlayPause = SKSpriteNode(texture: textureOverlayPause, color: .white, size: textureOverlayPause.size())
        
        overlayPause?.name = "overlay"
        overlayPause?.zPosition = 10
        
        
        // PAUSE
        let texturePause = SKTexture(imageNamed: "pause")
        
        pauseButton = SKSpriteNode(texture: texturePause, color: .white, size: texturePause.size())
        
        pauseButton?.name = "pause"
        pauseButton?.zPosition = 11
        
        //DEAD COUNT
        let textureSkull = SKTexture(imageNamed: "Skull")
        
        skull = SKSpriteNode(texture: textureSkull, size: textureSkull.size())
        skull?.zPosition = 11
        
        deadCount = SKLabelNode(text: "\(commonDeadCount)")
        deadCount?.fontName = "Futura Bold"
        deadCount?.fontSize = 40
        deadCount?.horizontalAlignmentMode = .left
        deadCount?.zPosition = 11
        
        // JOYSTICK
        let textureControllerB = SKTexture(imageNamed: "virtualControllerB")
        let textureControllerF = SKTexture(imageNamed: "virtualControllerF")
        
        virtualJoystickB = SKSpriteNode(texture: textureControllerB, color: .white, size: textureControllerB.size())
        
        virtualJoystickB?.scale(to: CGSize(width: 200, height: 200))
        virtualJoystickB?.name = "controllerBack"
        virtualJoystickB?.zPosition = 5
        virtualJoystickB?.alpha = 0.6
        
        virtualJoystickF = SKSpriteNode(texture: textureControllerF, color: .white, size: textureControllerF.size())
        
        virtualJoystickF?.name = "controllerFront"
        virtualJoystickF?.zPosition = 6
        virtualJoystickF?.alpha = 1
        
        // JUMP
        let textureJump = SKTexture(imageNamed: "jump")
        
        jumpButton = SKSpriteNode(texture: textureJump, color: .white, size: textureJump.size())
        
        jumpButton?.name = "jump"
        jumpButton?.zPosition = 6
        jumpButton?.alpha = 0.9
        
        // DASH
        let textureDash = SKTexture(imageNamed: "dash")
        
        dashButton = SKSpriteNode(texture: textureDash, color: .white, size: textureDash.size())
        
        dashButton?.name = "dash"
        dashButton?.zPosition = 6
        dashButton?.alpha = 0.9
        
        virtualJoystickB?.position = CGPoint(x: scene.size.width / -3 + scene.size.width / 50 , y: scene.size.height  / -5.3)
        virtualJoystickF?.position = CGPoint(x: scene.size.width / -3 + scene.size.width / 50, y: scene.size.height / -5.3)
        
        jumpButton?.position = CGPoint(x:  scene.size.width / 5 + scene.size.width / 9  , y:  scene.size.height  / -4)
        dashButton?.position = CGPoint(x: scene.size.width / 2.6 - scene.size.width / 200, y: scene.size.height / -14 )
        pauseButton?.position = CGPoint(x: scene.size.width / 2.6 + scene.size.width / 20, y: scene.size.height / 3.5 )
        
        skull?.position = CGPoint(x: scene.size.width / -2.24 + scene.size.width / 50, y: scene.size.height / 4.5 )
        deadCount?.position = CGPoint(x: scene.size.width / -2.46 + scene.size.width / 50, y: scene.size.height / 4.9 )
        
        overlayPause?.position = CGPoint (x: scene.size.width / 3 - scene.size.width / 3 , y: scene.size.height / 14)
        overlayShadow?.position = CGPoint (x: scene.size.width / 3 - scene.size.width / 200, y: scene.size.height / -12)
        exitButton?.position = CGPoint (x: scene.size.width / 20 - scene.size.width / 20 , y: scene.size.height / -4 + 20)
        soundButton?.position = CGPoint (x: 0 - scene.size.width / 13 , y: scene.size.height / -10 + 20)
        creditsButton?.position = CGPoint (x: 0 + scene.size.width / 13 , y: scene.size.height / -10 + 20)
        jogoPausado?.position = CGPoint (x: scene.size.width / 3 - scene.size.width / 3 , y: scene.size.height / 18 + 20)
        
        
        addOverlay()
        addPause()
        addJump()
        addDash()
        addController()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    // JOYSTICK
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches{
            
            let location = t.location(in: parent!)
            
            // Player não pular durante o pause
            if isOverlay && jumpButton!.frame.contains(location) {
                return
            }
            
            if let soundButton = soundButton, soundButton.contains(convert(location, to: overlayPause!)) {
                isSoundMuted.toggle() // Toggle do soundButton
            }
            
            
            
            if let exitButton = exitButton, exitButton.contains(convert(location, to: overlayPause!)) {
                // Volta ao menu inicial
                if let scene = SKScene(fileNamed: "MainMenu") {
                    scene.scaleMode = .aspectFill
                    self.scene?.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 3))
                }
            }

            
            if pauseButton!.frame.contains(location) {
                pauseTouch = t
                if isOverlay {
                    pauseButton?.alpha = 0.3

                    resumeGame()
                } else {
                    pauseGame()
                    pauseButton?.alpha = 1

                }
            }
            if jumpButton!.frame.contains(location){
                
                jumpButton?.alpha = 0.6
                let action = SKAction.wait(forDuration: 0.4)
                let reverse = SKAction.run {
                    self.jumpButton?.alpha = 0.9
                }
                run(SKAction.sequence([action, reverse]))
                jumpTouch = t
                
                target.onJoystickJumpBtnTouchStart()
            }
            
            if dashButton!.frame.contains(location){
                
                dashButton?.alpha = 0.6
                let action = SKAction.wait(forDuration: 0.4)
                let reverse = SKAction.run {
                    self.dashButton?.alpha = 0.9
                }
                run(SKAction.sequence([action, reverse]))
                
                dashTouch = t
                
                target.onJoystickDashBtnTouch(direction: normalForDash(vector: direction))
            }
            
            
            firstTouch(location: location, touch: t)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            for t in touches{
                if t == joystickTouch && !isOverlay {
                    let location = t.location(in: overlayPause!)
                    
                    if overlayShadow!.frame.contains(location) {
                        // Despausar o jogo e remover o overlay de pausa
                        resumeGame()
                    }
                    movementReset(size: scene!.size)
                }
                
                if t == jumpTouch {
                    target.onJoystickJumpBtnTouchEnd()
                }
            }
        }
    }
    
    func firstTouch(location: CGPoint, touch: UITouch ){
        
        if virtualJoystickF!.frame.contains(location) && location.x < 0{
            
            joystickInUse = true
            joystickTouch = touch
 
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            if touches.first == t{
                if t == joystickTouch && !isOverlay{
                    
                    let location = t.location(in: parent!)
                    
                    drag(location: location)
                    
                }
            }
            
        }
    }
    
    func drag(location: CGPoint) {
        
        if joystickInUse{
            //            print("in use")
            
            
            let point = CGPoint(x: location.x - virtualJoystickB!.position.x, y: location.y - virtualJoystickB!.position.y).normalize()
            
            let angle = atan2(point.y, point.x)
            
            joystickAngleRounded = atan2(point.y, point.x).rounded() * (CGFloat.pi / 4)
            
            direction = CGVector(dx: point.x, dy: point.y)
            
            
            let distanceFromCenter = CGFloat(virtualJoystickB!.frame.size.width / 2) // limita o botao pequeno
            
            distanceX = CGFloat(sin(angle - CGFloat.pi / 2) * distanceFromCenter) * -1
            distanceY = CGFloat(cos(angle - CGFloat.pi / 2) * -distanceFromCenter) * -1
           
            
            
            let radiusB = virtualJoystickB!.size.width / 2
           
            let sinalX = signNum(num: distanceX)
            let sinalY = signNum(num: distanceY)
               
            velocityX = radiusB * CGFloat(sinalX)
            velocityY = radiusB * CGFloat(sinalY)
            
            
            if distanceY * CGFloat(sinalY) > radiusB - 2 && distanceY * CGFloat(sinalY) < radiusB + 2{
                velocityX = 0
            }

            if virtualJoystickB!.frame.contains(location){
                
                virtualJoystickF!.position = location
                
            }else{
                
                virtualJoystickB!.position = CGPoint(x: virtualJoystickF!.position.x - distanceX , y: virtualJoystickF!.position.y - distanceY)
                
                virtualJoystickF!.position = location
            }
            if location.x > 0{
                movementReset(size: scene!.size)
            }
        }
    }
    
    
    func movementReset(size: CGSize){
        
        let moveback = SKAction.move(to: CGPoint(x: size.width / -3 + size.width / 50, y: size.height  / -5.3), duration: 0.1)
        moveback.timingMode = .linear
        virtualJoystickF?.run(moveback)
        virtualJoystickB?.run(moveback)
        joystickInUse = false
        velocityX = 0
        distanceY = 0
        direction = CGVector(dx: 0, dy: 0)
        
    }
    
    
    func addController(){
        
        addChild(virtualJoystickB!)
        addChild(virtualJoystickF!)
        
    }
    
    // JUMP
    
    func addJump(){
        addChild(jumpButton!)
    }
    
    
    // DASH
    
    func addDash(){
        
        
        addChild(dashButton!)
        
    }
    // PAUSE
    func addPause() {
        addChild(pauseButton!)
    }
    

    
    func actualDeadNumber(){
        deadCount!.text = "\(userDefaults.integer(forKey: "commonDeadCount"))"
    }
    
    //OVERLAY PAUSE - Tudo que estiver no overlay de Pause deve ser adicionado como filho de overlayPause.
    func addOverlay(){
        
        addChild(overlayPause!)
        overlayPause?.isHidden = true
        overlayPause?.addChild(overlayShadow!)
        overlayPause?.addChild(exitButton!)
        overlayPause?.addChild(soundButton!)
        overlayPause?.addChild(skull!)
        overlayPause?.addChild(deadCount!)
        overlayPause?.addChild(creditsButton!)
        overlayPause?.addChild(jogoPausado!)


    }
    // PAUSE GAME
    // PAUSE GAME
    func pauseGame() {
        isOverlay = true
        overlayPause?.isHidden = false
        scene?.isPaused = true
        
        target.onJoystickChange(direction: .zero, angle: 0)
        
        movementReset(size: scene!.size)
    }

    
    // RESUME GAME
    // RESUME GAME
    func resumeGame() {
        isOverlay = false
        overlayPause?.isHidden = true
        scene?.isPaused = false

        target.onJoystickChange(direction: .zero, angle: 0)
    }


}

