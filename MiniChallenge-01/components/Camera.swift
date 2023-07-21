//
//  Camera.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 13/07/23.
//

import SpriteKit

class CameraController {
        
    var camera: SKCameraNode!
    var target: SKNode?
    var boundaries: SKNode?
    var lastCameraPosition: CGPoint!
    var lastTime: TimeInterval = 0
    var cameraVelocity = CGVector(dx: 0, dy: 0)
    var deltaTime: TimeInterval = 0
    
    
    init(camera: SKCameraNode, target: SKNode?, boundaries: SKNode?) {
        self.camera = camera
        self.target = target
        self.boundaries = boundaries
        
        lastCameraPosition = self.camera.position
        
        if let _ = boundaries {
            self.createConstraints()
        }
    }
    
    func onFinishUpdate() {
        if let target = target{
            self.camera.run(.move(to: CGPoint(x: target.position.x, y: target.position.y + 180), duration: 0.3))
        }
    }
    
    func update(_ currentTime: TimeInterval) {
        deltaTime = currentTime - lastTime
        
    
      
        
        setCameraVelocity(currentTime)
        lastTime = currentTime
    }
    
    private func setCameraVelocity(_ currentTime: TimeInterval) {
        let currentCameraPosition = self.camera.position
        
        var deltaX = currentCameraPosition.x - lastCameraPosition.x
        var deltaY =  currentCameraPosition.y - lastCameraPosition.y
        
        var velocityX = deltaX / deltaTime
        var velocityY = deltaY / deltaTime
        
        self.cameraVelocity = .init(dx: velocityX, dy: velocityY)
        
        lastCameraPosition = currentCameraPosition
    }
    
    private func createConstraints() {
    
        let boundLeft = self.boundaries!.calculateAccumulatedFrame().minX + self.camera.scene!.size.width / 2
        let boundRight = self.boundaries!.calculateAccumulatedFrame().maxX - self.camera.scene!.size.width / 2
        
        let boundariesConstraint = SKConstraint.positionX(SKRange(lowerLimit: boundLeft, upperLimit: boundRight))
        
        self.camera.constraints = [
            boundariesConstraint
        ]
    }
}
