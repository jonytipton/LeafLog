//
//  Plant.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 5/9/23.
//

import CoreData
import Foundation
import UIKit

@objc(Plant)
class Plant: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var commonName: String?
    @NSManaged public var cycle: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var defaultPhoto: Data?
    @NSManaged public var displayPhoto: Data?
    @NSManaged public var isFavorited: Bool
    @NSManaged public var nickname: String?
    @NSManaged public var scientificName: String?
    @NSManaged public var sunlight: [String]?
    @NSManaged public var userPhotos: [UIImage]
    @NSManaged public var watering: String?
    @NSManaged public var reminderDay: String?
    @NSManaged public var reminderFrequency: Int64
}
