//
//  FavouriteCity+CoreDataProperties.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/13.
//
//

import Foundation
import CoreData


extension FavouriteCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteCity> {
        return NSFetchRequest<FavouriteCity>(entityName: "FavouriteCity")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var weatherModel: NSSet?

}

// MARK: Generated accessors for weatherModel
extension FavouriteCity {

    @objc(addWeatherModelObject:)
    @NSManaged public func addToWeatherModel(_ value: WeatherModel)

    @objc(removeWeatherModelObject:)
    @NSManaged public func removeFromWeatherModel(_ value: WeatherModel)

    @objc(addWeatherModel:)
    @NSManaged public func addToWeatherModel(_ values: NSSet)

    @objc(removeWeatherModel:)
    @NSManaged public func removeFromWeatherModel(_ values: NSSet)

}

extension FavouriteCity : Identifiable {

}
