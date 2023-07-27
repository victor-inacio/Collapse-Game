//
//  Persistence.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 25/07/23.
//

import Foundation
import SpriteKit

let userDefaults = UserDefaults.standard
var minDeadCount = userDefaults.integer(forKey: "minDeadCount")
var commonDeadCount = userDefaults.integer(forKey: "commonDeadCount")
var levelName = userDefaults.string(forKey: "highLevelName")
var winGame = userDefaults.bool(forKey: "winGame")

extension SKScene{
    func setUserDefaults(_ a : String){
        userDefaults.set(a, forKey: "highLevelName")
    }
    
    func setUserDefaults(){
        userDefaults.set(nil, forKey: "highLevelName")
    }
    
    func resetUserDefaults(_ a: String){
        userDefaults.set(nil, forKey: a)
    }
}

extension Player{
    func setDieUserDefault(_ a : Int){
        userDefaults.set(a, forKey: "commonDeadCount")
    }
}
