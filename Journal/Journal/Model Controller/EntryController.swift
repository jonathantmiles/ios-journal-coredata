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
    
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - CRUD
    
    func createEntry(withTitle title: String, bodyText: String, mood: EntryMood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntryRepresentation(with entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.identifier = entryRepresentation.identifier
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = entryRepresentation.mood
        
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: EntryMood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        deleteEntryFromServer(entry: entry)
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving managed oject context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func fetchSingleEntryFromPersistentStore(withID identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        let moc = CoreDataStack.shared.mainContext
        do {
            let entries = try moc.fetch(fetchRequest)
            return entries.first
        } catch {
            NSLog("Error fetching single entry: \(error)")
            return nil
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let url = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("error fetching multiple entries from server: \(error)")
                completion(error)
            }
            guard let data = data else { return }
            
            do {
                var entryReps: [EntryRepresentation] = []
                let decodedData = try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values
                entryReps = Array(decodedData)
                for entryRep in entryReps {
                    let entry = self.fetchSingleEntryFromPersistentStore(withID: entryRep.identifier)
                    if entry != nil {
                        if entry! == entryRep {
                        } else if entry! != entryRep {
                            self.updateEntryRepresentation(with: entry!, entryRepresentation: entryRep)
                        }
                    } else {
                        let _ = Entry(entryRepresentation: entryRep)
                    }
                }
                self.saveToPersistentStore()
                completion(nil)
            } catch {
                    NSLog("Error snchronizing data:\(error)")
            }
        }.resume()
    }
    
    // MARK: - Networking
    
    func put(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let url = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        do {
            let data = try JSONEncoder().encode(entry)
            request.httpBody = data
        } catch {
            NSLog("Error PUTting data to the server: \(error)")
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error with URLSession: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let url = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error with URLSession: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    // MARK: - Properties
    
    let baseURL: URL = URL(string: "https://jonathantmilesjournal.firebaseio.com/")!
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
}
