//
//  NumberTileView.swift
//  swift-4096
//
//  Created by Yuichiro Mukai on 12/13/14.
//  Copyright (c) 2014 Yuichiro Mukai. All rights reserved.
//

import UIKit

class NumberTileView : UIView {
    
    var value: Int {
        didSet {
            numberLabel.text = "\(value)"
        }
    }
    
    var numberLabel: UILabel
 
    init(value v: Int, font ft: UIFont, frame f: CGRect, textColor tc: UIColor, backgroundColor bc: UIColor, cornerRadius cr: CGFloat) {

        numberLabel = UILabel(frame: f)
        value = v
        super.init(frame: f)
    

        backgroundColor = bc
        layer.cornerRadius = cr

        numberLabel.font = ft
        numberLabel.textAlignment = NSTextAlignment.Center
        numberLabel.textColor = tc
        numberLabel.text = "\(value)"

        self.addSubview(numberLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder) not supported")
    }
}
