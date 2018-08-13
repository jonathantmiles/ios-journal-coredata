//
//  EntriesTableViewCell.swift
//  Journal
//
//  Created by Jonathan T. Miles on 8/13/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit

class EntriesTableViewCell: UITableViewCell {

    private func updateViews() {
        guard let entry = entry, let date = entry.timestamp else { return }
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let prettyDate = formatter.string(from: date)
        timestampLabel.text = prettyDate
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
}
