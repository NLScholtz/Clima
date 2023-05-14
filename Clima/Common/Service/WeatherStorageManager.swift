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
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func getFavouriteCities() -> [FavouriteCity] {
        var favouriteWeather = [FavouriteCity]()
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCity")
        
        do {
            favouriteWeather = try context?.fetch(request) as! [FavouriteCity]
        } catch {
            print("Weather could not be retrieved: \(error.localizedDescription)")
        }
        return favouriteWeather
    }
    
    func getOfflineWeather() -> [WeatherModel] {
        var weather = [WeatherModel]()
        let request = NSFetchRequest<NSManagedObject>(entityName: "WeatherModel")
        
        do {
            weather = try context?.fetch(request) as! [WeatherModel]
        } catch {
            print("Weather could not be retrieved: \(error.localizedDescription)")
        }
        return weather
    }
    
    func saveContext() {
        do {
            try context?.save()
        } catch {
            print("Weather could not be saved: \(error.localizedDescription)")
        }
    }
    
    func saveFavouriteCity(object: [String: String]) -> FavouriteCity {
        let weatherCity = NSEntityDescription.insertNewObject(forEntityName: "FavouriteCity", into: context!) as! FavouriteCity
        weatherCity.name = object["name"]
        //weatherCity.date = Date()
        saveContext()
        return weatherCity
    }
    
    func createNewWeatherModel() -> WeatherModel {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "WeatherModel", into: context!) as! WeatherModel
        return newEntity
    }
    
    func entityFor(cityName: String) -> FavouriteCity? {
        let fetchRequest: NSFetchRequest<FavouriteCity>
        fetchRequest = FavouriteCity.fetchRequest()
       
        fetchRequest.predicate = NSPredicate(
            format: "name LIKE %@", "\(cityName)")
        
        do {
            let object = try context?.fetch(fetchRequest)
            return object?.first
        } catch {
            return nil
        }
    }
    
    func deleteFavouriteCity(index: Int) -> [FavouriteCity] {
        var favouriteCity = getFavouriteCities()
        context?.delete(favouriteCity[index])
        favouriteCity.remove(at: index)
        saveContext()
        return favouriteCity
    }
    
    func deleteAllFavouriteWeather() {
        let weatherCity = getFavouriteCities()
         
        for i in weatherCity {
            context?.delete(i)
        }
        saveContext()
    }
    
    func deleteOfflineWeatherData() {
        let weather = getOfflineWeather()
        
        for i in weather {
            context?.delete(i)
        }
        saveContext()
    }
}
