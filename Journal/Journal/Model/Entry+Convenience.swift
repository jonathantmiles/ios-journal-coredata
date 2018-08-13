//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jonathan T. Miles on 8/13/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: managedObjectContext)
        self.title =  title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
    }
}
