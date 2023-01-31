//
//  Loopable.swift
//  Rick and Morty
//
//  Created by Nuha Alharbi on 30/01/2023.
//

import Foundation

protocol Loopable {
    func allProprities() -> [(String, Any)]
}

extension Loopable {
    func allProprities() -> [(String, Any)] {
        
        var result : [(String, Any)] = []
        
        let mirror = Mirror(reflecting: self)

        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            return []
        }
        
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            
            result.append((property, value))
        }
        
        return result
        
    }
    
}
