//
//  Component.swift
//  SlidingTiles
//
//  Created by Julie Langmann on 11/15/20.
//

import SpriteKit
import Foundation


enum TileType: Int {
    case unknown = 0, one, two, three, four, five, six
    var spriteName: UIColor {
        let spriteNames = [
            UIColor.red,
            UIColor.blue,
            UIColor.yellow,
            UIColor.orange,
            UIColor.purple,
            UIColor.green]

        return spriteNames[rawValue - 1]
    }

    var highlightedSpriteName: String {
        return spriteName.accessibilityName + "-Highlighted"
    }
    static func random() -> TileType {
        return TileType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
}

// MARK: - Tile
class Tile: CustomStringConvertible, Hashable {
  
    var hashValue: Int {
        return row * 10 + column
    }
  
    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    
    }
 
    var description: String {
        return "type:\(tileType) square:(\(column),\(row))"
    }
  
    var column: Int
    var row: Int
    let tileType: TileType
    var sprite: SKSpriteNode?
  
    var label:String
  
    init(column: Int, row: Int, tileType: TileType, label:String) {
        self.column = column
        self.row = row
        self.tileType = tileType
        self.label = label
  }
}

