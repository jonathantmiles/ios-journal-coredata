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
    
    // MARK: - CRUD
    
    func createEntry(withTitle title: String, bodyText: String) {
        let entry = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
        deleteEntryFromServer(entry: entry)
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
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
}
