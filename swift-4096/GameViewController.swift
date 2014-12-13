//
//  GameViewController.swift
//  swift-4096
//
//  Created by Yuichiro Mukai on 12/13/14.
//  Copyright (c) 2014 Yuichiro Mukai. All rights reserved.
//

import UIKit

class GameViewController : ViewController {
    
    var scoreView: ScoreView?
    
    var paddingTop: CGFloat = 150.0
    
    init(dimension d: Int, goal g: Int) {
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
        // ゲームボードのビューを定義する
        setupGameboard()
        // スワイプの動作を定義する
        setupSwipeControls()
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
        
    }
    
    func setupSwipeControls() {
        
    }
    
    // vをこのViewController内で配置する際の左上座標を返す
    func getOffsetXOfCenter(view v: UIView) -> CGFloat {
        let thisWidth = view.bounds.size.width
        let viewWidth = v.bounds.size.width
        let offsetX = 0.5 * (thisWidth - viewWidth)
        return offsetX > 0 ? offsetX : 0
    }
}
