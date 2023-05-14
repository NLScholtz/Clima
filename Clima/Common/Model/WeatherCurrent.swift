//
//  WeatherCurrent.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/09.
//

import Foundation
import UIKit

struct WeatherCurrent {
    
    var temperature : Int = 0
    var city : String = ""
    let condition: Int = 0
    
    func weatherConditionState(condition: Int) -> String {
        switch condition {
        case 500...504: return "RAINY"
        case 801...804: return "CLOUDY"
        case 800: return "SUNNY"
        default: return "SUNNY"
        }
    }
    
    func weatherIconState(condition: Int) -> UIImage {
        switch condition {
        case 500...504: return UIImage(named: "rain") ?? UIImage(named: "rain")!
        case 801...804: return UIImage(named: "partlysunny") ?? UIImage(named: "partlysunny")!
        case 800: return UIImage(named: "clear") ?? UIImage(named: "clear")!
        default: return UIImage(named: "clear") ?? UIImage(named: "clear")!
        }
    }
    
    func weatherBackgroundState(condition: Int) -> UIImage {
        switch condition {
        case 500...504: return UIImage(named: "forest_rainy") ?? UIImage(named: "forest_rainy")!
        case 801...804: return UIImage(named: "forest_cloudy") ?? UIImage(named: "forest_cloudy")!
        case 800: return UIImage(named: "forest_sunny") ?? UIImage(named: "forest_sunny")!
        default: return UIImage(named: "forest_sunny") ?? UIImage(named: "forest_sunny")!
        }
    }
    
    
    func weatherParentViewState(condition: Int) -> UIColor {
        switch condition {
        case 500...504: return UIColor.rainyColor
        case 801...804: return UIColor.cloudyColor
        case 800: return UIColor.sunnyColor
        default: return UIColor.sunnyColor
        }
    }
}

extension UIColor {
    static var rainyColor: UIColor {
        return UIColor(named: "Rainy") ?? UIColor.label
    }

    static var sunnyColor: UIColor {
        return UIColor(named: "Sunny") ?? UIColor.label
    }

    static var cloudyColor: UIColor {
        return UIColor(named: "Cloudy") ?? UIColor.label
    }
}
