//
//  GameModel.swift
//  swift-4096
//
//  Created by Yuichiro Mukai on 12/13/14.
//  Copyright (c) 2014 Yuichiro Mukai. All rights reserved.
//

import UIKit

protocol GameModelProtocol : class {
    func changeScore(score: Int)
    func reset()
    func insertTile(position: (Int, Int), value: Int)
}

class GameModel : NSObject {
    
    var dimension: Int
    var goal: Int
    var score: Int = 0 {
        didSet {
            delegate.changeScore(score)
        }
    }

    var delegate: GameModelProtocol
    
    var gameboard: Gameboard
    
    init(dimension: Int, goal: Int, delegate: GameModelProtocol) {
        self.dimension = dimension
        self.goal = goal
        self.delegate = delegate
        self.gameboard = Gameboard(dimension: dimension)
        super.init()

        reset()
    }
    
    // ゲームの状態を初期化
    func reset() {
        score = 0
        gameboard.setAll(Tile.Empty)
    }
    
    // ゲームを開始する
    func start() {
        let pos1 = getRandomEmptyPosition()
        insertTile(pos1, value: 2)
        let pos2 = getRandomEmptyPosition()
        insertTile(pos2, value: 2)
    }
    
    func getRandomEmptyPosition() -> (Int, Int) {
        let emptyPositions = gameboard.getEmptyPositions()

        let index = Int(arc4random_uniform(UInt32(emptyPositions.count - 1)))
        return emptyPositions[index]
    }
    
    func insertTile(position: (Int, Int), value: Int) {
        let (x, y) = position
        switch gameboard[y, x] {
        case .Empty:
            gameboard[y, x] = Tile.Tile(value)
            delegate.insertTile(position, value: value)
        case .Tile:
            break
        }
    }
    
    // タイルを表現する列挙型
    enum Tile {
        case Empty
        case Tile(Int)
    }
    
    struct Gameboard {
        
        var dimension: Int
        var tiles: [Tile]
        
        init(dimension: Int) {
            self.dimension = dimension
            tiles = [Tile](count: dimension * dimension, repeatedValue:Tile.Empty)
        }
        
        subscript(row: Int, col: Int) -> Tile {
            get {
                assert(row >= 0 && row < dimension)
                assert(col >= 0 && col < dimension)
                return tiles[row * dimension + col]
            }
            set {
                assert(row >= 0 && row < dimension)
                assert(col >= 0 && col < dimension)
                tiles[row * dimension + col] = newValue
            }
        }
        
        // mutatingをつけないとsubscriptを利用できない
        mutating func setAll(tile: Tile) {
            for y in 0..<dimension {
                for x in 0..<dimension {
                    self[y, x] = tile
                }
            }
        }
        
        mutating func getEmptyPositions() -> [(Int, Int)] {
            var positions = Array<(Int, Int)>()
            for y in 0..<dimension {
                for x in 0..<dimension {
                    switch self[y, x] {
                    case .Empty:
                        positions += [(x, y)]
                    case .Tile:
                        break
                    }
                }
            }
            return positions
        }
    }
}
