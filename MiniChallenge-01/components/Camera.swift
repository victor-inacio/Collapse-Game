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
    
    init(camera: SKCameraNode, target: SKNode?, boundaries: SKNode?) {
        self.camera = camera
        self.target = target
        self.boundaries = boundaries
        
        if let _ = boundaries {
            self.createConstraints()
        }
    }
    
    func onFinishUpdate() {
        if let target = target{
            self.camera.run(.move(to: CGPoint(x: target.position.x, y: target.position.y + 150), duration: 0.3))
        }
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
