//
//  Math.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//

import Foundation
import SpriteKit

extension CGVector {
    func toCGPoint() -> CGPoint {
        return .init(x: self.dx, y: self.dy)
    }
    
    static func *(vec1: CGVector, vec2: CGVector) -> Self {
        return .init(dx: vec1.dx * vec2.dx, dy: vec1.dy * vec2.dy)
    }
    
    static func *(vec1: CGVector, int: CGFloat) -> Self {
        return .init(dx: vec1.dx * int, dy: vec1.dy * int)
    }
}


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

func signNum(num: CGFloat) -> Int {
    if (num < 0) {return -1}
    if (num > 0) {return 1}
        
    return 0
}


extension Array where Element == SKTexture {
    init(format: String, frameCount: ClosedRange<Int>){
        self = frameCount.map({ (index) in
            let imageName = String(format: format, "\(index)")
            return SKTexture(imageNamed: imageName)
        })
    }
}
