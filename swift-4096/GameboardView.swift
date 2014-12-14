//
//  GameboardView.swift
//  swift-4096
//
//  Created by Yuichiro Mukai on 12/13/14.
//  Copyright (c) 2014 Yuichiro Mukai. All rights reserved.
//

import UIKit

class GameboardView : UIView {
    
    var dimension: Int

    var width: CGFloat
    
    var tileWidth: CGFloat
    var tilePadding: CGFloat
    
    var board: Board
    
    let tilePopStartScale: CGFloat = 0.1
    let tilePopMaxScale: CGFloat = 1.1
    let tilePopDelay: NSTimeInterval = 0.05
    let tileExpandTime: NSTimeInterval = 0.18
    let tileContractTime: NSTimeInterval = 0.08
    
    let tileMergeStartScale: CGFloat = 1.0
    let tileMergeExpandTime: NSTimeInterval = 0.08
    let tileMergeContractTime: NSTimeInterval = 0.08
    
    let perSquareSlideDuration: NSTimeInterval = 0.08
    
    init(dimension d: Int, width w: CGFloat, cornerRadius cr: CGFloat, tileWidth tw: CGFloat, backgroundColor bc: UIColor, tileBackgroundColor tbc: UIColor) {
        
        dimension = d
        width = w
        
        tileWidth = tw
        
        board = Board(dimension: dimension)
        
        let totalTilesPadding = (width - tileWidth * CGFloat(dimension))
        tilePadding = totalTilesPadding / CGFloat(dimension + 1)
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: width))
        
        setup(
            cornerRadius: cr,
            backgroundColor: bc,
            tileBackgroundColor: tbc
        )
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder : NSCoder) not supported")
    }
    
    func setup(cornerRadius cr: CGFloat, backgroundColor bc: UIColor, tileBackgroundColor tbc: UIColor) {
        layer.cornerRadius = cr
        backgroundColor = bc

        setupBackground(tileBackgroundColor: tbc)
    }
    
    func setupBackground(tileBackgroundColor tbc: UIColor) {
        for y in 0..<dimension {
            for x in 0..<dimension {
                let tile = TileView(
                    frame: CGRect(
                        x: getPositionOfTile(x), y: getPositionOfTile(y), width: tileWidth, height: tileWidth
                    ),
                    backgroundColor: tbc,
                    cornerRadius: 4.0
                )
                self.addSubview(tile)
            }
        }
    }
    
    func placeNumberTile(position: (Int, Int), value: Int) {
        let (x, y) = position
        let tile = NumberTileView(value: value,
            font: UIFont(name: "HelveticaNeue-Bold", size: 24.0) ??
                UIFont.systemFontOfSize(24.0),
            frame: CGRect(
                x: 0, y: 0, width: tileWidth, height: tileWidth
            ),
            textColor: UIColor.grayColor(),
            backgroundColor: UIColor.whiteColor(),
            cornerRadius: 4.0
        )
        
        tile.frame.offset(dx: getPositionOfTile(x), dy: getPositionOfTile(y))
        self.addSubview(tile)
        
        board[y, x] = tile
    }
    
    func getPositionOfTile(pos: Int) -> CGFloat {
        return CGFloat(pos) * (tileWidth + tilePadding) + tilePadding
    }
    
    func move(from f: (Int, Int), to t: (Int, Int), value v: Int) {
        let (sx, sy) = f
        let (tx, ty) = t

        var fromTileView = board[sy, sx]!
        let toTileView = board[ty, tx]
        
        var finalFrame = fromTileView.frame
        finalFrame.origin.x = getPositionOfTile(tx)
        finalFrame.origin.y = getPositionOfTile(ty)
        
        board[sy, sx] = nil
        board[ty, tx] = fromTileView
        
        UIView.animateWithDuration(perSquareSlideDuration,
            delay: 0.0,
            options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: { () -> Void in
                fromTileView.frame = finalFrame
            },
            completion: { (finished: Bool) -> Void in
                fromTileView.value = v
                toTileView?.removeFromSuperview()
            }
        )
    }   
    
    struct Board {
        
        var dimension: Int
        var tiles: [NumberTileView?]
        
        init(dimension: Int) {
            self.dimension = dimension
            tiles = [NumberTileView?](count: dimension * dimension, repeatedValue:nil)
        }
        
        subscript(row: Int, col: Int) -> NumberTileView? {
            get {
                assert(inBound(row, col))
                return tiles[row * dimension + col]
            }
            set {
                assert(inBound(row, col))
                tiles[row * dimension + col] = newValue
            }
        }
        
        func inBound(position: (Int, Int)) -> Bool {
            let (x, y) = position
            return x >= 0 && x < dimension && y >= 0 && y < dimension
        }
    }
}
