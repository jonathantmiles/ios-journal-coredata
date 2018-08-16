//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jonathan T. Miles on 8/15/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    var title: String
    var bodyText: String
    var identifier: String
    var timestamp: Date
    var mood: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
        lhs.title == rhs.title &&
        lhs.bodyText == rhs.bodyText &&
        lhs.identifier == rhs.identifier &&
        lhs.timestamp == rhs.timestamp &&
        lhs.mood == rhs.mood
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return
        rhs == lhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
        !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return
        rhs != lhs
}
