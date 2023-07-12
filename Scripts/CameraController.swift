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
    
    private func createConstraints() {
        let boundX1 = self.boundaries!.frame.minX
        let boundX2 = self.boundaries!.frame.maxX
        let boundY1 = self.boundaries!.frame.maxY
        let boundY2 = self.boundaries!.frame.minY
        
        let cameraCamX1 = self.camera.scene!.frame.minX
        let cameraCamY1 = self.camera.scene!.frame.minY
        
        let distanceFromCamCenterToCamBoundsHorizonally = self.camera.position.x - cameraCamX1
        let distanceFromCamCenterToCamBoundsVertically = self.camera.position.y - cameraCamY1
        
        let maxCameraX1 = boundX1 + distanceFromCamCenterToCamBoundsHorizonally
        let maxCameraX2 = boundX2 - distanceFromCamCenterToCamBoundsHorizonally
        let maxCameraY1 = boundY1 - distanceFromCamCenterToCamBoundsVertically
        let maxCameraY2 = boundY2 + distanceFromCamCenterToCamBoundsVertically
        
        let horizontalCamRange = SKRange(lowerLimit: maxCameraX1, upperLimit: maxCameraX2)
        let verticalCamRange = SKRange(lowerLimit: maxCameraY2, upperLimit: maxCameraY1)
        let distanceFromPlayerRange = SKRange(constantValue: 0)

        let horizontalBorderConstraint = SKConstraint.positionX(horizontalCamRange)
        let verticalBorderConstraint = SKConstraint.positionY(verticalCamRange)
        let distanceFromPlayerConstraint = SKConstraint.distance(distanceFromPlayerRange, to: self.target!)
        self.camera.constraints = [
            distanceFromPlayerConstraint,
            horizontalBorderConstraint,
            verticalBorderConstraint
        ]
    }
}
