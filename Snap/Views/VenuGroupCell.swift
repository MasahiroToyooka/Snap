//
//  VenuGroupCell.swift
//  Snap
//
//  Created by 豊岡正紘 on 2019/07/22.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import UIKit

class VenueGroupCell: UICollectionViewCell {
    
     let horizontalController = AppsHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(horizontalController.view)
        horizontalController.view.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
