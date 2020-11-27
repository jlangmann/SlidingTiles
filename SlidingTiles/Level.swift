//
//  Level.swift
//  SlidingTiles
//
//  Created by Julie Langmann on 11/15/20.
//

import Foundation

let numColumns = 5
let numRows = 5


class Level {
    private var tiles = Array2D<Tile>(columns: numColumns, rows: numRows)

    func tile(atColumn column: Int, row: Int) -> Tile? {
        precondition(column >= 0 && column < numColumns)
        precondition(row >= 0 && row < numRows)
        return tiles[column, row]
    }

    func shuffle() -> Set<Tile> {
        return createInitialTiles()
    }

    private func createInitialTiles() -> Set<Tile> {
        var set: Set<Tile> = []
        var index:Int = 0
        // 1
        let max = numRows * numColumns
        for row in 0..<numRows {
            for column in 0..<numColumns {
                // 2
                let tileType = TileType.random()
                let val = String(max - (row*numColumns + column))
                
                // 3
                let tile = Tile(column: column, row: row, tileType: tileType, label:val)
                
                if (row == 0 && column == 0) {
                    
                }

                tiles[column, row] = tile
                print(val)
                index += 1
                // 4
                set.insert(tile)
            }
        }
        return set
    }

    func performSwap(_ swap: Swap) {
        let columnA = swap.tileA.column
        let rowA = swap.tileA.row
        let columnB = swap.tileB.column
        let rowB = swap.tileB.row

        tiles[columnA, rowA] = swap.tileB
        swap.tileB.column = columnA
        swap.tileB.row = rowA

        tiles[columnB, rowB] = swap.tileA
        swap.tileA.column = columnB
        swap.tileA.row = rowB
    }
}
