//
//  ScoreView.swift
//  swift-4096
//
//  Created by Yuichiro Mukai on 12/13/14.
//  Copyright (c) 2014 Yuichiro Mukai. All rights reserved.
//

import UIKit

class ScoreView : UIView {
   
    var width : CGFloat = 140.0
    var height : CGFloat = 40.0
    
    var defaultFrame : CGRect = CGRect(x: 0, y: 0, width: 140.0, height: 40)
    var scoreLabel : UILabel
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    init(backgroundColor bc: UIColor, textColor tc: UIColor, font f: UIFont, cornerRadius cr: CGFloat) {
        
        scoreLabel = UILabel(frame: defaultFrame)
        super.init(frame: defaultFrame)
        
        backgroundColor = bc
        
        scoreLabel.textAlignment = NSTextAlignment.Center
        scoreLabel.font = f
        layer.cornerRadius = cr
        scoreLabel.textColor = tc
        
        self.addSubview(scoreLabel)
        score = 0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder : NSCoder) not supported")
    }
}
