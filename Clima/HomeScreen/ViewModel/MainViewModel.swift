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
}

class MainViewModel: NSObject & CLLocationManagerDelegate {
    
    private weak var delegate: MainViewModelDelegate?
    private let locationManager = CLLocationManager()
    private let weatherManager = WeatherManager()
    private let coreManager = WeatherStorageManager()
    private var weatherModel: [WeatherModel]?
    var cityName: String?
    private var weatherCurrent = WeatherCurrent()
    private(set) var favouriteCity: [FavouriteCity] = []
    var numberOfForecast: Int{ return weatherModel?.count ?? 0 }
    var i = Int()
    var isUpdateData = Bool()
    
    let forecastDays = ["Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    init(delegate: MainViewModelDelegate) {
        self.delegate = delegate
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
        if isUpdateData {
            coreManager.showFavouriteWeather(object: weather , i: i)
        } else {
            if let city = coreManager.entityFor(cityName: cityName) {
                guard let weatherModelArray = weatherModel else { return }
                city.weatherModel = NSSet(array: weatherModelArray)
                coreManager.saveContext()
            } else {
                let city = coreManager.saveWeatherToFavourties(object: weather)
                guard let weatherModelArray = weatherModel else { return }
                city.weatherModel = NSSet(array: weatherModelArray)
                coreManager.saveContext()
            }
        }

    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func cityReceived(city: String) {
        print(city)
        weatherManager.getWeatherDataByCity(city: city) { (result) in
            switch result {
            case .success(let weatherModel):
                self.cityName = weatherModel.city.name
                self.weatherModel = [WeatherModel]()
                for weather in weatherModel.list {
                    let weatherObject = self.coreManager.createNewEntity()
                    weatherObject.maxTemperature = weather.main.temp_max
                    weatherObject.minTemperature = weather.main.temp_min
                    weatherObject.weatherConditionID = Int32(weather.weather.first?.id ?? 800)
                    weatherObject.currentTemperature = weather.main.temp
                    self.weatherModel?.append(weatherObject)
                }
                DispatchQueue.main.async {
                    self.delegate?.weatherUpdated()
                }
                print(weatherModel)
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("long = \(location.coordinate.longitude)", "lat = \(location.coordinate.latitude)")
            let latitude = location.coordinate.latitude.description
            let longitude = location.coordinate.longitude.description
            
            weatherManager.getWeatherData(lat: latitude, lon: longitude) { (result) in
                switch result {
                case .success(let weatherModel):
                    self.cityName = weatherModel.city.name
                    self.weatherModel = [WeatherModel]()
                    for weather in weatherModel.list {
                        let weatherObject = self.coreManager.createNewEntity()
                        weatherObject.maxTemperature = weather.main.temp_max
                        weatherObject.minTemperature = weather.main.temp_min
                        weatherObject.weatherConditionID = Int32(weather.weather.first?.id ?? 800)
                        weatherObject.currentTemperature = weather.main.temp
                        self.weatherModel?.append(weatherObject)
                    }
                    DispatchQueue.main.async {
                        self.delegate?.weatherUpdated()
                    }
                    print(weatherModel)
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func offlineCitySelected(cityName: String) {
        if let city = coreManager.entityFor(cityName: cityName) {
            self.cityName = cityName
            self.weatherModel = city.weatherModel?.allObjects as? [WeatherModel]
            delegate?.weatherUpdated()
        }
    }
}

