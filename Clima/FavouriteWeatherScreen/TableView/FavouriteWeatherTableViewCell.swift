//
//  FavouriteWeatherTableViewCell.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/12.
//

import UIKit

class FavouriteWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var favouriteCityName: UILabel!
    @IBOutlet weak var favouriteCityDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
