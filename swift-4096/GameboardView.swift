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
    }
    
    func getPositionOfTile(pos: Int) -> CGFloat {
        return CGFloat(pos) * (tileWidth + tilePadding) + tilePadding
    }

}
