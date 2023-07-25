//
//  Math.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//

import Foundation
import SpriteKit

extension CGPoint{
    
    func normalize() -> Self {
        
        let magnitude = sqrt(self.x * self.x + self.y * self.y)
        
        let newDx = self.x / magnitude
        let newDy = self.y / magnitude
        
        return CGPoint(x: newDx, y: newDy)
    }
    
    func toCGVector() -> CGVector {
        return .init(dx: self.x, dy: self.y)
    }
    
}

func signNum(num: CGFloat) -> CGFloat {
    if (num < 0) {return -1}
    if (num > 0) {return 1}
        
    return 0
}

func normalForDash(vector: CGVector) -> CGVector{
    
    let sinalX = signNum(num: vector.dx)
    let sinalY = signNum(num: vector.dy)
    
    switch true {
        
    case vector.dy == 0 && vector.dx == 0:
        
        return CGVector(dx: 0, dy: 0)
        
    case vector.dy > 0.95 || vector.dy < -0.95:
        
        return CGVector(dx: 0, dy: sinalY)
    
    case vector.dx > 0.95 || vector.dx < -0.95:

        return CGVector(dx: sinalX , dy: 0)
   
    default:
        return CGVector(dx: (0.5 * sinalX) * 2, dy: (0.5 * sinalY) * 2)
    }
    
}


extension Array where Element == SKTexture {
    init(format: String, frameCount: ClosedRange<Int>){
        self = frameCount.map({ (index) in
            let imageName = String(format: format, "\(index)")
            return SKTexture(imageNamed: imageName)
        })
    }
}
