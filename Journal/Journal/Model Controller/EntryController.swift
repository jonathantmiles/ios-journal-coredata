//
//  EntryController.swift
//  Journal
//
//  Created by Jonathan T. Miles on 8/13/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Persistence
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            moc.save()
        } catch {
            NSLog("Error saving managed oject context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> Entry {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    // MARK: - CRUD
    
    
    // MARK: - Properties
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
}
