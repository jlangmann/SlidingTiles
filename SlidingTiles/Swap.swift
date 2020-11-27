//
//  Swap.swift
//  SlidingTiles
//
//  Created by Julie Langmann on 11/15/20.
//

import Foundation
struct Swap: CustomStringConvertible {
  let tileA: Tile
  let tileB: Tile
  
  init(tileA: Tile, tileB: Tile) {
    self.tileA = tileA
    self.tileB = tileB
  }
  
  var description: String {
    return "swap \(tileA) with \(tileB)"
  }
}
