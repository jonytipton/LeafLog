//
//  CoreDataManager.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 5/9/23.
//

import CoreData
import Foundation

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    private init() {
        
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        persistentContainer = NSPersistentContainer(name: "LeafLog")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent container: \(error)")
            }
        }
    }
}
