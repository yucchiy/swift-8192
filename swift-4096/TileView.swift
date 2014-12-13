//
//  TileView.swift
//  swift-4096
//
//  Created by Yuichiro Mukai on 12/13/14.
//  Copyright (c) 2014 Yuichiro Mukai. All rights reserved.
//

import UIKit

class TileView : UIView {
    
    init(frame f: CGRect, backgroundColor bc: UIColor, cornerRadius cr: CGFloat) {
        super.init(frame: f)
        setup(backgroundColor: bc, cornerRadius: cr)
    }
    
    func setup(backgroundColor bc: UIColor, cornerRadius cr: CGFloat) {
        backgroundColor = bc
        layer.cornerRadius = cr
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder : NSCoder) not supported")
    }

}
