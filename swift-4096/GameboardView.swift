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
    
    init(dimension d: Int, width w: CGFloat, cornerRadius cr: CGFloat, tileWidth tw: CGFloat, backgroundColor bc: UIColor, tileBackgroundColor tbc: UIColor) {
        
        dimension = d
        width = w
        
        tileWidth = tw
        
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
        var posX = tilePadding, posY = tilePadding
        for y in 0..<dimension {
            posY = CGFloat(y) * (tileWidth + tilePadding) + tilePadding
            for x in 0..<dimension {
                posX = CGFloat(x) * (tileWidth + tilePadding) + tilePadding
                let tile = TileView(
                    frame: CGRect(x: posX, y: posY, width: tileWidth, height: tileWidth),
                    backgroundColor: tbc,
                    cornerRadius: 4.0
                )
                self.addSubview(tile)
            }
        }
    }

}
