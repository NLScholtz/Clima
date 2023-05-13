//
//  WeatherStorageManager.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/12.
//

import Foundation
import CoreData
import UIKit

class WeatherStorageManager {
    
    static var shareInstance = WeatherStorageManager()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveWeatherToFavourties(object: [String: String]) -> FavouriteCity {
        let weatherCity = NSEntityDescription.insertNewObject(forEntityName: "FavouriteCity", into: context!) as! FavouriteCity
        weatherCity.name = object["name"]
        weatherCity.date = Date()
        
        do {
            try context?.save()
        } catch {
            print("Weather could not be saved: \(error.localizedDescription)")
        }
        return weatherCity
    }
    
    func createNewEntity() -> WeatherModel {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "WeatherModel", into: context!) as! WeatherModel
        return newEntity
    }
    
    func saveContext() {
        do {
            try context?.save()
        } catch {
            print("Weather could not be saved: \(error.localizedDescription)")
        }
    }
    
    func getWeatherData() -> [FavouriteCity] {
        var favouriteWeather = [FavouriteCity]()
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCity")
        
        do {
            favouriteWeather = try context?.fetch(request) as! [FavouriteCity]
        } catch {
            print("Can't retreive data: \(error.localizedDescription)")
        }
        return favouriteWeather
    }
    
    func deleteData(index: Int) -> [FavouriteCity] {
        var weather = getWeatherData()
        context?.delete(weather[index])
        weather.remove(at: index)
        
        do {
            try context?.save()
        } catch {
            print("Can not delete data: \(error.localizedDescription)")
        }
        return weather
    }
    
    func showFavouriteWeather(object: [String: String], i: Int) {
        let weatherCity = getWeatherData()
        weatherCity[i].name = object["name"]
        
        do {
            try context?.save()
        } catch {
            print("Data could not be shown \(error.localizedDescription)")
        }
    }
    
    func deleteAllFavouriteWeather() {
        let weatherCity = getWeatherData()
         
        for i in weatherCity {
            context?.delete(i)
        }
        
        do {
            try context?.save()
        } catch {
            print("Could not delete data: \(error.localizedDescription)")
        }
    }
    
    func entityFor(cityName: String) -> FavouriteCity? {
        let fetchRequest: NSFetchRequest<FavouriteCity>
        fetchRequest = FavouriteCity.fetchRequest()
       
        fetchRequest.predicate = NSPredicate(
            format: "name LIKE %@", "\(cityName)"
        )
        
        do {
            let object = try context?.fetch(fetchRequest)
            return object?.first
        } catch {
            return nil
        }
    }
    
    func fetchWeatherDataFor(city: FavouriteCity) -> [WeatherModel] {
        return city.weatherModel?.allObjects as! [WeatherModel]
    }
}
