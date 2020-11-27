//
//  GameScene.swift
//  SlidingTiles
//
//  Created by Julie Langmann on 11/15/20.
//

import Foundation

import SpriteKit
import GameplayKit


class GameScene: SKScene {

    var swipeHandler: ((Swap) -> Void)?
    var level: Level!

    let tileWidth: CGFloat = 50.0
    let tileHeight: CGFloat = 50.0

    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
        let background = SKSpriteNode()
        background.size = size
        background.color = UIColor.white
        addChild(background)
        
        addChild(gameLayer)

        let layerPosition = CGPoint(
            x: -tileWidth * CGFloat(numColumns) / 2,
            y: -tileHeight * CGFloat(numRows) / 2)

        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
    }
    
    func addSprites(for tiles: Set<Tile>) {
        for tile in tiles {
            let sprite = SKSpriteNode()
            sprite.color = tile.tileType.spriteName
            sprite.size = CGSize(width: tileWidth, height: tileHeight)
            sprite.position = pointFor(column: tile.column, row: tile.row)
            let text = SKLabelNode(text: tile.label)
            if (tile.label == "0")
            {
                sprite.color = UIColor.black
            }
            else
            {
                sprite.addChild(text)
            }
            tilesLayer.addChild(sprite)
            tile.sprite = sprite
        }
    }

    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * tileWidth + tileWidth / 2,
            y: CGFloat(row) * tileHeight + tileHeight / 2
        )
    }

    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(numColumns) * tileWidth &&
            point.y >= 0 && point.y < CGFloat(numRows) * tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        guard let touch = touches.first else { return }
        let location = touch.location(in: tilesLayer)
        // 2
        let (success, column, row) = convertPoint(location)
        if success {
            // 3
            if let tile = level.tile(atColumn: column, row: row) {
                // 4
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      // 1
      guard swipeFromColumn != nil else { return }

      // 2
      guard let touch = touches.first else { return }
      let location = touch.location(in: tilesLayer)

      let (success, column, row) = convertPoint(location)
      if success {

        // 3
        var horizontalDelta = 0, verticalDelta = 0
        if column < swipeFromColumn! {          // swipe left
          horizontalDelta = -1
        } else if column > swipeFromColumn! {   // swipe right
          horizontalDelta = 1
        } else if row < swipeFromRow! {         // swipe down
          verticalDelta = -1
        } else if row > swipeFromRow! {         // swipe up
          verticalDelta = 1
        }

        // 4
        if horizontalDelta != 0 || verticalDelta != 0 {
          trySwap(horizontalDelta: horizontalDelta, verticalDelta: verticalDelta)

          // 5
          swipeFromColumn = nil
        }
      }
    }
    
    private func trySwap(horizontalDelta: Int, verticalDelta: Int) {
      // 1
      let toColumn = swipeFromColumn! + horizontalDelta
      let toRow = swipeFromRow! + verticalDelta
      // 2
      guard toColumn >= 0 && toColumn < numColumns else { return }
      guard toRow >= 0 && toRow < numRows else { return }
      // 3
      if let toTile = level.tile(atColumn: toColumn, row: toRow),
        let fromTile = level.tile(atColumn: swipeFromColumn!, row: swipeFromRow!) {
        // 4
        print("*** swapping \(fromTile) with \(toTile)")
        if let handler = swipeHandler {
          let swap = Swap(tileA: fromTile, tileB: toTile)
          handler(swap)
        }
      }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      swipeFromColumn = nil
      swipeFromRow = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      touchesEnded(touches, with: event)
    }
    func animate(_ swap: Swap, completion: @escaping () -> Void) {
      let spriteA = swap.tileA.sprite!
      let spriteB = swap.tileB.sprite!

      spriteA.zPosition = 100
      spriteB.zPosition = 90

      let duration: TimeInterval = 0.3

      let moveA = SKAction.move(to: spriteB.position, duration: duration)
      moveA.timingMode = .easeOut
      spriteA.run(moveA, completion: completion)

      let moveB = SKAction.move(to: spriteA.position, duration: duration)
      moveB.timingMode = .easeOut
      spriteB.run(moveB)

    }
}


