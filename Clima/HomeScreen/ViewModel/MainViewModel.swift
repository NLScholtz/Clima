//
//  MainViewModel.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/08.
//

import Foundation
import CoreLocation
import UIKit
import CoreData

protocol MainViewModelDelegate: AnyObject {
    func weatherUpdated()
    func city(isFavourite: Bool)
}

class MainViewModel {
    
    private weak var delegate: MainViewModelDelegate?
    
    private let weatherManager = WeatherManager()
    private var coreManager = WeatherStorageManager()
    private var weatherModel: [WeatherModel]?
    private var weatherCurrent = WeatherCurrent()
    private(set) var favouriteCity: [FavouriteCity] = []
    var numberOfForecast: Int{ return weatherModel?.count ?? 0 }
    var locationManager: LocationManagable?
    var cityName: String?
    
    var forecastDays = ["Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    init(delegate: MainViewModelDelegate, coreManager: WeatherStorageManager, locationManager: LocationManagable) {
        self.delegate = delegate
        self.coreManager = coreManager
        self.locationManager = locationManager
        //coreManager.deleteAllFavouriteWeather()
    }
    
    func currentTemperature(at index: Int) -> String {
        return "\(Int(weatherModel?[index].currentTemperature ?? 0.0))°"
    }
    
    func minTemperature(at index: Int) -> String {
        return "\(Int(weatherModel?[index].minTemperature ?? 0.0))°"
    }
    
    func maxTemperature(at index: Int) -> String {
        return "\(Int(weatherModel?[index].maxTemperature ?? 0.0))°"
    }
    
    func weatherCondtion(at index: Int) -> String {
        return "\(weatherCurrent.weatherConditionState(condition: Int(weatherModel?.first?.weatherConditionID ?? 800)))°"
    }
    
    func weatherConditionImage(at index: Int) -> UIImage {
        return weatherCurrent.weatherIconState(condition: Int(weatherModel?.first?.weatherConditionID ?? 800))
    }
    
    func weatherBackgroundState(at index: Int) -> UIImage {
        return weatherCurrent.weatherBackgroundState(condition: Int(weatherModel?.first?.weatherConditionID ?? 800))
    }
    
    func weatherColorState(at index: Int) -> UIColor {
        return weatherCurrent.weatherParentViewState(condition: Int(weatherModel?.first?.weatherConditionID ?? 800))
    }
    
    func saveWeatherOffline(cityName: String) {
        let weather = ["name": cityName.description]
        if let _ = coreManager.createEntityFor(cityName: cityName) {
        } else {
            let _ = coreManager.saveFavouriteCity(object: weather)
        }
    }

    func setupLocationManager() {
        locationManager?.setupLocationManager(locationDelegate: self)
    }
    
    func retrieveOfflineWeather() {
        self.weatherModel = coreManager.getOfflineWeather()
        cityName = weatherModel?.first?.cityName
        DispatchQueue.main.async {
            self.delegate?.weatherUpdated()
        }
    }
    
    func cityDetermined(city: String) {
        print(city)
        if CheckNetworkConnection.isConnectedToNetwork() {
            weatherManager.getWeatherResponseByCity(city: city) { (result) in
                DispatchQueue.main.async {
                    self.processWeatherResponse(result)
                }
            }
        } else {
            retrieveOfflineWeather()
        }
    }
    
    func processWeatherResponse(_ result: WeatherManager.Result<WeatherResponses>) {
        switch result {
        case .success(let weatherModel):
            self.coreManager.deleteOfflineWeatherData()
            self.weatherModel = [WeatherModel]()
            self.cityName = weatherModel.city.name
            for weather in weatherModel.list {
                let weatherObject = self.coreManager.createNewWeatherModel()
                weatherObject.cityName = weatherModel.city.name
                weatherObject.maxTemperature = weather.main.temp_max
                weatherObject.minTemperature = weather.main.temp_min
                weatherObject.weatherConditionID = Int32(weather.weather.first?.id ?? 800)
                weatherObject.currentTemperature = weather.main.temp
                self.weatherModel?.append(weatherObject)
            }
            self.coreManager.saveContext()
            
            DispatchQueue.main.async {
                if let _ = self.coreManager.createEntityFor(cityName: self.cityName ?? "") {
                    self.delegate?.city(isFavourite: true)
                } else {
                    self.delegate?.city(isFavourite: false)
                }
                self.delegate?.weatherUpdated()
            }
            
            print(weatherModel)
        case .failure(let error):
            print("Error \(error)")
        }
    }
}

extension MainViewModel: LocationManagerDelegate {

    func locationDetermined(lat: Double, lon: Double) {
        weatherManager.getWeatherResponse(lat: lat.description, lon: lon.description) { (result) in
            DispatchQueue.main.async {
                self.processWeatherResponse(result)
            }
        }
    }
}

