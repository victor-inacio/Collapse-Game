//
//  PhysicsCategory.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 13/07/23.
//

import Foundation

enum PhysicsCategory: UInt32{
    case player = 1
    case trigger = 2
    case door = 3
    case wall = 4
    case fallen = 5
    case floor = 6
    case fallenBlocks = 7
    case limit = 8
    case water = 9
}
