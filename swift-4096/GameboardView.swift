//
//  GameboardView.swift
//  swift-4096
//
//  Created by Yuichiro Mukai on 12/13/14.
//  Copyright (c) 2014 Yuichiro Mukai. All rights reserved.
//

import UIKit

protocol GameboardViewProtocol {
    func onFinishedAnimation()
}

class GameboardView : UIView {
    
    var dimension: Int

    var width: CGFloat
    
    var tileWidth: CGFloat
    var tilePadding: CGFloat
    
    var board: Board
    
    let perSquareSlideDuration: NSTimeInterval = 0.08
    
    var tilesAnimations: [TilesAnimation]
    
    var delegate: GameboardViewProtocol
    
    init(dimension d: Int, delegate dg: GameboardViewProtocol, width w: CGFloat, cornerRadius cr: CGFloat, tileWidth tw: CGFloat, backgroundColor bc: UIColor, tileBackgroundColor tbc: UIColor) {
        
        dimension = d
        width = w
        
        tileWidth = tw
        
        delegate = dg
        
        board = Board(dimension: dimension)
        
        let totalTilesPadding = (width - tileWidth * CGFloat(dimension))
        tilePadding = totalTilesPadding / CGFloat(dimension + 1)
        
        tilesAnimations = Array<TilesAnimation>()
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
    
    func pushMoves(moves: [GameModel.MoveInfo]) {
        var anim = TilesAnimation()
        if moves.count > 0 {
            for moveInfo in moves {
                anim.animations.append(MoveAnimation(from: moveInfo.from, to: moveInfo.to, value: moveInfo.value))
            }
            tilesAnimations.append(anim)
        }
    }
    
    func fireAnimation() {
        UIView.animateWithDuration(perSquareSlideDuration,
            delay: 0.0,
            options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: { () -> Void in
                if self.tilesAnimations.count == 0 {
                    return
                }

                var anims = self.tilesAnimations.first!
                if anims.animations.count > 0 {
                    for anim in anims.animations {
                        let (sx, sy) = anim.from
                        let (tx, ty) = anim.to
                        
                        var fromTileView = self.board[sy, sx]!
                        let toTileView = self.board[ty, tx]

                        var finalFrame = fromTileView.frame
                        finalFrame.origin.x = self.getPositionOfTile(tx)
                        finalFrame.origin.y = self.getPositionOfTile(ty)
                        
                        self.board[sy, sx] = nil
                        self.board[ty, tx] = fromTileView
                        UIView.animateWithDuration(0,
                            delay: 0.0,
                            options: UIViewAnimationOptions.BeginFromCurrentState,
                            animations: { () -> Void in
                                fromTileView.frame = finalFrame
                            },
                            
                            completion: { (finished: Bool) -> Void in
                                toTileView?.removeFromSuperview()
                                fromTileView.value = fromTileView.value > anim.value ? fromTileView.value : anim.value
                            }
                        )
                    }
                }
            },
            
            completion: { (finished: Bool) -> Void in
                if self.tilesAnimations.count > 0 {
                    self.tilesAnimations.removeAtIndex(0)
                    self.fireAnimation()
                } else {
                    self.delegate.onFinishedAnimation()
                }
            }
        )
    }
    
    func debug() {
        var str = "\n"
        for y in 0..<dimension {
            str += "| "
            for x in 0..<dimension {
                if self.board[y, x] == nil {
                    str += "   | "
                } else {
                    str += " * | "
                }
            }
            str += "\n"
        }
        NSLog(str)
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
    
    // 1タイルのアニメーション
    struct MoveAnimation {
        var from: (Int, Int)
        var to: (Int, Int)
        var value: Int
        init(from f: (Int, Int), to t: (Int, Int), value v: Int) {
            from = f
            to = t
            value = v
        }
    }
    
    // 1度に移動するタイルのアニメーション
    struct TilesAnimation {
        var animations: [MoveAnimation]
        init() {
            animations = Array<MoveAnimation>()
        }
    }
}
