//
//  Plant+CoreDataProperties.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/24/23.
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
    @NSManaged public var data: NSObject?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var defaultPhotos: NSObject?
    @NSManaged public var nickname: String?
    @NSManaged public var scientificName: String?
    @NSManaged public var sunlight: NSObject?
    @NSManaged public var userPhotos: [NSData]?
    @NSManaged public var watering: String?
    @NSManaged public var displayPhoto: Data?

}

extension Plant : Identifiable {

}
