//
//  FavouriteWeatherViewModel.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/13.
//

import Foundation

protocol FavouriteWeatherViewModelDelegate {
    func favouriteWeather(object: [String:String], index: Int)
}

class FavouriteWeatherViewModel {
    
    var favouriteCity = [FavouriteCity]()
    var delegate: FavouriteWeatherViewControllerDelegate?
    var weatherManager = WeatherStorageManager()
    var numberOfFavouriteCities: Int { return favouriteCity.count }
    
    func retrieveFavouriteCities() {
        favouriteCity = weatherManager.getFavouriteCities()
    }
    
    func favouriteCityName(at index: Int) -> String {
        return "\(favouriteCity[index].name?.description ?? "")"
    }
}
