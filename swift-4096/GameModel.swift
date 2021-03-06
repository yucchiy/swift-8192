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
    func pushMoves(moves: [GameModel.MoveInfo])
    func fireAnimation()
}

class GameModel : NSObject, GameboardViewProtocol {
    
    var dimension: Int
    var goal: Int
    var score: Int = 0 {
        didSet {
            delegate.changeScore(score)
        }
    }

    var delegate: GameModelProtocol
    
    var gameboard: Gameboard
    
    var inAction: Bool = false
    
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
    
    // 空いている場所をランダムに取得する
    func getRandomEmptyPosition() -> (Int, Int) {
        let emptyPositions = gameboard.getEmptyPositions()

        let index = Int(arc4random_uniform(UInt32(emptyPositions.count - 1)))
        return emptyPositions[index]
    }
    
    // タイルを挿入する
    func insertTile(position: (Int, Int), value: Int) {
        let (x, y) = position
        switch gameboard[y, x] {
        case .Empty:
            gameboard[y, x] = Tile.Tile(value, false)
            delegate.insertTile(position, value: value)
        case .Tile:
            break
        }
    }
    
    // 移動
    func move(command c: MoveCommand) {
        if inAction {
            return
        }
        
        inAction = true
        
        // 動かすタイルの順番を定義する
        // 例えば上に動かす場合は, 上にあるタイルから順番に
        // 動かさないと正しい動作を行えない
        var xs: [Int]
        var ys: [Int]
        switch c.direction {
        case .Up:
            xs = Array(0..<dimension)
            ys = Array(1..<dimension)
        case .Right:
            xs = Array(reverse(0..<(dimension-1)))
            ys = Array(0..<dimension)
        case .Down:
            xs = Array(0..<dimension)
            ys = Array(reverse(0..<(dimension-1)))
        case .Left:
            xs = Array(1..<dimension)
            ys = Array(0..<dimension)
        }
        prepare()

        var moves = Array<MoveInfo>()
        do {
            moves.removeAll(keepCapacity: false)
            for y in ys {
                for x in xs {
                    let moveInfo = moveAndMerge((x, y), command: c)
                    if moveInfo != nil {
                        moves.append(moveInfo!)
                    }
                }
            }
            
            delegate.pushMoves(moves)
        } while !moves.isEmpty
        
        delegate.fireAnimation()
    }
    
    // 移動前の準備
    func prepare() {
        for y in 0..<dimension {
            for x in 0..<dimension {
                switch gameboard[y, x] {
                case .Empty:
                    break
                case var .Tile(value, merged):
                    gameboard[y, x] = Tile.Tile(value, false)
                }
            }
        }
    }
    
    func onFinishedAnimation() {
        // Todo: 判定
        
        // ランダムにタイルを突っ込む
        insertTile(getRandomEmptyPosition(), value: 2)
        inAction = false
    }
    
    // デバッグ用関数
    func debug() {
        var str = "\n"
        for y in 0..<dimension {
            str += "| "
            for x in 0..<dimension {
                switch gameboard[y, x] {
                case .Empty:
                    str += "   |"
                case let .Tile(value, merged):
                    str += " \(value) |"
                }
            }
            str += "\n"
        }
        NSLog(str)
    }
    
    // タイルの移動と統合を行って、動いた情報を返す
    func moveAndMerge(position: (Int, Int), command: MoveCommand) -> MoveInfo? {
        let (x, y) = position
        
        var value: Int
        var merged: Bool
        switch gameboard[y, x] {
        case .Empty:
            // 該当する場所が空のタイルであればなにもしない
            return nil
        case let .Tile(v, m):
            value = v
            merged = m
            break
        }
        
        let (nx, ny) = getNextPosition(position, command: command)
        if gameboard.inBound((nx, ny)) {
            // 移動後のタイルがボード内に入るように
            switch gameboard[ny, nx] {
            case .Empty:
                // 移動先が空のタイル
                // そのまま移動
                gameboard[y, x] = Tile.Empty
                gameboard[ny, nx] = Tile.Tile(value, merged)
                return MoveInfo(from: (x, y), to: (nx, ny), value: value)
            case let .Tile(value_, merged_):
                if (!merged && !merged_ && value == value_) {
                    // どちらのタイルも非統合でかつ値が同じ場合の
                    // 時のみタイルの統合を行う
                    gameboard[y, x] = Tile.Empty
                    gameboard[ny, nx] = Tile.Tile(value * 2, true)

                    score += value
                    return MoveInfo(from: (x, y), to: (nx, ny), value: value * 2)
                }
            default:
                break
            }
        }
        
        return nil
    }
    
    func getNextPosition(position: (Int, Int), command: MoveCommand) -> (Int, Int) {
        let (x, y) = position
        switch command.direction {
        case .Up:
            return (x, y - 1)
        case .Right:
            return (x + 1, y)
        case .Down:
            return (x, y + 1)
        case .Left:
            return (x - 1, y)
        }
    }
    
    // タイルを表現する列挙型
    enum Tile {
        case Empty
        case Tile(Int, Bool) // value, merged?
    }
    
    // 近傍を表す列挙型
    enum Direction {
        case Up
        case Right
        case Down
        case Left
    }
    
    // ゲームモデルを動かすためのコマンド
    struct MoveCommand {
        var direction: Direction
        init(direction d: Direction) {
            direction = d
        }
    }
    
    struct MoveInfo {
        var from: (Int, Int)
        var to: (Int, Int)
        var value: Int
        init(from f: (Int, Int), to t: (Int, Int), value v: Int) {
            from = f
            to = t
            value = v
        }
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
