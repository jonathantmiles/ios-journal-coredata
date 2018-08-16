//
//  Entry+Encodable.swift
//  Journal
//
//  Created by Jonathan T. Miles on 8/15/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    enum CodingKeys: String, CodingKey {
        //case context
        case title
        case bodyText
        case identifier
        case timestamp
        case mood
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // try container.encode(context, forKey: .context)
        try container.encode(title, forKey: .title)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(mood, forKey: .mood)
    }
}
