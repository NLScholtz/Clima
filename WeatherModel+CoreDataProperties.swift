//
//  WeatherModel+CoreDataProperties.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/12.
//
//

import Foundation
import CoreData


extension WeatherModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherModel> {
        return NSFetchRequest<WeatherModel>(entityName: "WeatherModel")
    }

    @NSManaged public var currentTemperature: Double
    @NSManaged public var maxTemperature: Double
    @NSManaged public var minTemperature: Double
    @NSManaged public var weatherConditionID: Int32
    @NSManaged public var weatherDate: Date?
    @NSManaged public var favouriteCities: FavouriteCity?

}

extension WeatherModel : Identifiable {

}
