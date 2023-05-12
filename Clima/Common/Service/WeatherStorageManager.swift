//
//  WeatherStorageManager.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/12.
//

import Foundation
import CoreData

class WeatherStorageManager {
    
    private var container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "ClimaContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading CoreData: \(error.localizedDescription)")
            }
        }
    }
    
    var fetchFavouritesCities: [FavouriteCity]? {
        let request = NSFetchRequest<FavouriteCity>(entityName: "FavouriteCity")
        var favouriteCities: [FavouriteCity]?
        do {
            favouriteCities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching CoreData: \(error.localizedDescription)")
        }
        return favouriteCities
    }
    
    func isFavouriteCity(city: FavouriteCity) -> Bool {
        let fetchRequest: NSFetchRequest<FavouriteCity>
        fetchRequest = FavouriteCity.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "name LIKE %@", "Robert"
        )

        //let context = container.viewContext

        //let objects = try context.fetch(fetchRequest)
        return true
    }
    
    func storeFavouriteCity(city: String) {
        let newFavouriteCity = FavouriteCity(context: container.viewContext)
        newFavouriteCity.cityName = city
            do {
                try container.viewContext.save()
            } catch let error {
                print("Error saving city: \(error.localizedDescription)")
            }
    }
    
    func removeFavouriteCity(city: FavouriteCity) {
        
    }
    
}
