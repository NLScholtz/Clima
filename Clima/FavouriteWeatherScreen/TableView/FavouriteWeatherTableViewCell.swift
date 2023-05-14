//
//  FavouriteWeatherTableViewCell.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/12.
//

import UIKit

class FavouriteWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var favouriteCityName: UILabel!
   // @IBOutlet weak var favouriteCityDate: UILabel!
    
    var favouriteWeather: FavouriteCity! {
        didSet {
            favouriteCityName.text = favouriteWeather.name?.description
            //favouriteCityDate.text = favouriteWeather.date?.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
