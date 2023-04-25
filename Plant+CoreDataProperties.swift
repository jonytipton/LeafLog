//
//  Plant+CoreDataProperties.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/25/23.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var commonName: String?
    @NSManaged public var cycle: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var defaultPhotos: [NSData]?
    @NSManaged public var displayPhoto: Data?
    @NSManaged public var nickname: String?
    @NSManaged public var scientificName: String?
    @NSManaged public var sunlight: [String]?
    @NSManaged public var userPhotos: [NSData]?
    @NSManaged public var watering: String?

}

extension Plant : Identifiable {

}
