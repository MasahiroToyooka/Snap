//
//  File.swift
//  Snap
//
//  Created by 豊岡正紘 on 2019/05/16.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import UIKit

class FoodImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        return .init(width: 150, height: 200)
    }
}

class VenueCell: BaseVenueCell {
    
    let venueName = UILabel(text: "スターバックスコーヒー", font: .boldSystemFont(ofSize: 25), numberOfLines: 0)
    
    let distanceLabel = UILabel(text: "500m", font: .boldSystemFont(ofSize: 15))
    
    let foodImage = FoodImageView(image: #imageLiteral(resourceName: "hot-coffee-rounded-cup-on-a-plate-from-side-view"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        foodImage.contentMode = .scaleAspectFill
        foodImage.clipsToBounds = true
        
        let verticalStack = UIStackView(arrangedSubviews: [UIView(), UIView(), venueName, UIView(), UIView(), distanceLabel])
        verticalStack.axis = .vertical
        verticalStack.spacing = 4
        verticalStack.distribution = .fill
        verticalStack.alignment = .center
        
        let horizonStack = UIStackView(arrangedSubviews: [verticalStack, foodImage])
        horizonStack.distribution = .fill
        horizonStack.alignment = .center
        horizonStack.spacing = 8
        addSubview(horizonStack)
        
       horizonStack.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
