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
    func receivedCity(city: String)
}

class MainViewModel: NSObject & CLLocationManagerDelegate  {
    
    private weak var delegate: MainViewModelDelegate?
    private let locationManager = CLLocationManager()
    private let weatherManager = WeatherManager()
    private let coreManager = WeatherStorageManager()
    private var weatherModel: WeatherResponses?
    private var weatherCurrent = WeatherCurrent()
    private var numberOfForecast: Int { return weatherModel?.list.count ?? 0 }
    private(set) var favouriteCity: [FavouriteCity] = []
    
    let forecastDays = ["Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    init(delegate: MainViewModelDelegate) {
        self.delegate = delegate
        
    }
    
    var cityName: String {
        return "\(weatherModel!.city.name)"
    }
    
    func currentTemperature(at index: Int) -> String {
        return "\(weatherModel?.list[index].main.temp.description ?? "")"
    }
    
    func minTemperature(at index: Int) -> String {
        return "\(weatherModel!.list[index].main.temp_min.description)"
    }
    
    func maxTemperature(at index: Int) -> String {
        return "\(weatherModel!.list[index].main.temp_max.description)"
    }
    
    func weatherCondtion(at index: Int) -> String {
        return "\(weatherCurrent.weatherConditionState(condition: weatherModel?.list[index].weather[index].id ?? 800))"
    }
    
    func weatherConditionImage(at index: Int) -> UIImage {
        return weatherCurrent.weatherIconState(condition: weatherModel?.list[index].weather.first!.id ?? 800)
    }
    
    func weatherBackgroundState(at index: Int) -> UIImage {
        return weatherCurrent.weatherBackgroundState(condition: weatherModel!.list[index].weather[index].id)
    }
    
    func weatherColorState(at index: Int) -> UIColor {
        return weatherCurrent.weatherParentViewState(condition: weatherModel!.list[index].weather[index].id)
    }
    
    func saveWeatherOffline(image: UIImage, cityName: String) -> UIImage {
        coreManager.storeFavouriteCity(city: cityName)
        
        if image == UIImage(systemName: "bookmark") {
            return UIImage(systemName: "bookmark.fill") ?? UIImage(systemName: "bookmark.fill")!
        } else {
            return UIImage(systemName: "bookmark") ?? UIImage(systemName: "bookmark")!
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
                self.weatherModel = weatherModel
                DispatchQueue.main.async {
                    //self.updateWeatherInfo(info: weatherModel)
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
                    self.weatherModel = weatherModel
                    DispatchQueue.main.async {
                        //self.updateWeatherInfo(info: weatherModel)
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
}

