//
//  RestaurantCell.swift
//  RestaurantFinder
//
//  Created by Kevin VanEvery on 7/31/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var restaurantTitleLabel: UILabel!
    @IBOutlet weak var restaurantCheckinCountLabel: UILabel!
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
