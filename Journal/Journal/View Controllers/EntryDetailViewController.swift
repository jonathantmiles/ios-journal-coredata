//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jonathan T. Miles on 8/13/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }

    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextField.text else { return }
        if entry != nil {
            if let entry = entry {
                entryController?.update(entry: entry, title: title, bodyText: bodyText)
            }
        } else {
            entryController?.createEntry(withTitle: title, bodyText: bodyText)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        if isViewLoaded {
            if entry != nil {
                if let entry = entry {
                    title = entry.title
                    titleTextField.text = entry.title
                    bodyTextField.text = entry.bodyText
                }
            } else {
                title = "Create Entry"
            }
        }
    }
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    
}
