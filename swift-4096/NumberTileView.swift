//
//  NumberTileView.swift
//  swift-4096
//
//  Created by Yuichiro Mukai on 12/13/14.
//  Copyright (c) 2014 Yuichiro Mukai. All rights reserved.
//

import UIKit

class NumberTileView : UIView {
 
    init(value v: Int, font ft: UIFont, frame f: CGRect, textColor tc: UIColor, backgroundColor bc: UIColor, cornerRadius cr: CGFloat) {
        
        super.init(frame: f)
        backgroundColor = bc
        layer.cornerRadius = cr

        let labelView = UILabel(frame: f)
        
        labelView.font = ft
        labelView.text = "\(v)"
        labelView.textAlignment = NSTextAlignment.Center
        labelView.textColor = tc
        
        addSubview(labelView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder) not supported")
    }
}
