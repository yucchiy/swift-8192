//
//  GameViewController.swift
//  swift-4096
//
//  Created by Yuichiro Mukai on 12/13/14.
//  Copyright (c) 2014 Yuichiro Mukai. All rights reserved.
//

import UIKit

class GameViewController : ViewController, GameModelProtocol {
    
    var scoreView: ScoreView?
    var gameboardView: GameboardView?
    
    var game: GameModel?
    
    var paddingTop: CGFloat = 150.0
    
    var dimension: Int
    var goal: Int
    
    var gameboardWidth: CGFloat = 320.0
    var tileWidth: CGFloat = 60.0
    
    init(dimension d: Int, goal g: Int) {
        dimension = d
        goal = g
        super.init(nibName: nil, bundle: nil)
    }
    
    required override init(coder aDecoder: NSCoder) {
        fatalError("init(coder) not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = UIColor.whiteColor()
        
        // スコアボードのビューを定義する
        setupScore()
        
        let game = GameModel(
            dimension: dimension,
            goal: goal,
            delegate: self)
        
        self.game = game

        // ゲームボードのビューを定義する
        setupGameboard()
        // スワイプの動作を定義する
        setupSwipeControls()
        
        game.start()
        
    }
    
    func setupScore() {
        let scoreView = ScoreView(
            backgroundColor: UIColor.blackColor(),
            textColor: UIColor.whiteColor(),
            font:
            UIFont(name: "HelveticaNeue-Bold", size: 16.0) ??
            UIFont.systemFontOfSize(16.0)
            , cornerRadius: 6.0)
        
        // 座標を設定
        scoreView.frame.origin.x = getOffsetXOfCenter(view: scoreView)
        scoreView.frame.origin.y = paddingTop
        view.addSubview(scoreView)
        
        // 初期スコアを設定
        scoreView.score = 0
        self.scoreView = scoreView
    }
    
    func setupGameboard() {
        let delegate = game!
        let gameboardView = GameboardView(
            dimension: dimension,
            delegate: delegate,
            width: gameboardWidth,
            cornerRadius: 6.0,
            tileWidth: tileWidth,
            backgroundColor: UIColor.blackColor(),
            tileBackgroundColor: UIColor.darkGrayColor()
        )
        
        let scoreViewHeight = scoreView?.height
        gameboardView.frame.origin.x = getOffsetXOfCenter(view: gameboardView)
        gameboardView.frame.origin.y = paddingTop + scoreViewHeight! + 20.0
        view.addSubview(gameboardView)
        
        self.gameboardView = gameboardView
    }
    
    func changeScore(score: Int) {
        let view = self.scoreView!
        view.score = score
    }
    
    func reset() {
        
    }
    
    func insertTile(position: (Int, Int), value: Int) {
        let view = self.gameboardView!
        view.placeNumberTile(position, value: value)
    }
    
    func pushMoves(moves: [GameModel.MoveInfo]) {
        let view = self.gameboardView!
        view.pushMoves(moves)
    }
    
    func fireAnimation() {
        let view = self.gameboardView!
        view.fireAnimation()
    }
    
    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("up:"))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("down:"))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("left:"))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("right:"))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc(up:)
    func upCommand(r: UIGestureRecognizer!) {
        sendCommand(GameModel.MoveCommand(direction: GameModel.Direction.Up))
    }
    
    @objc(down:)
    func downCommand(r: UIGestureRecognizer!) {
        sendCommand(GameModel.MoveCommand(direction: GameModel.Direction.Down))
    }
    
    @objc(left:)
    func leftCommand(r: UIGestureRecognizer!) {
        sendCommand(GameModel.MoveCommand(direction: GameModel.Direction.Left))
    }

    @objc(right:)
    func rightCommand(r: UIGestureRecognizer!) {
       sendCommand(GameModel.MoveCommand(direction: GameModel.Direction.Right))
    }
    
    func sendCommand(command: GameModel.MoveCommand) {
        let g = game!
        g.move(command: command)
    }
    
    // vをこのViewController内で配置する際の左上座標を返す
    func getOffsetXOfCenter(view v: UIView) -> CGFloat {
        let thisWidth = view.bounds.size.width
        let viewWidth = v.bounds.size.width
        let offsetX = 0.5 * (thisWidth - viewWidth)
        return offsetX > 0 ? offsetX : 0
    }
}
