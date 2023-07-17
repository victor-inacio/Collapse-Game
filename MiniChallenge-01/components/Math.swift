//
//  Math.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//

import Foundation


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
