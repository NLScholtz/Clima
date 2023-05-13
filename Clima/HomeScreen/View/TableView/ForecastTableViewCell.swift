//
//  TableViewCell.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/11.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var forecastDay: UILabel!
    @IBOutlet weak var forecastIcon: UIImageView!
    @IBOutlet weak var forecastTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
