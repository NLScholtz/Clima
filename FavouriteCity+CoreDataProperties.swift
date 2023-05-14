//
//  FavouriteCity+CoreDataProperties.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/14.
//
//

import Foundation
import CoreData


extension FavouriteCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteCity> {
        return NSFetchRequest<FavouriteCity>(entityName: "FavouriteCity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
}

extension FavouriteCity : Identifiable { }
