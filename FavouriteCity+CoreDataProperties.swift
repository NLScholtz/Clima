//
//  FavouriteCity+CoreDataProperties.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/12.
//
//

import Foundation
import CoreData


extension FavouriteCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteCity> {
        return NSFetchRequest<FavouriteCity>(entityName: "FavouriteCity")
    }

    @NSManaged public var cityName: String?

}

extension FavouriteCity : Identifiable {

}
