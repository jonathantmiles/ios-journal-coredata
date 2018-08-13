//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Jonathan T. Miles on 8/13/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntriesTableViewCell
        
        cell.entry = entryController.entries[indexPath.row]
        
        /* ~~~ unnecessary duplication ~~~
        let entry = entryController.entries[indexPath.row]
        cell.titleLabel.text = entry.title
        cell.bodyLabel.text = entry.bodyText
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let prettyDate = formatter.string(from: entry.timestamp!)
        cell.timestampLabel.text = prettyDate
        */
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entry = entryController.entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
            } catch {
                moc.reset()
            }
            
            tableView.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEntryDetail" {
            let destVC = segue.destination as! EntryDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destVC.entry = entryController.entries[indexPath.row]
                destVC.entryController = entryController
            }
        } else if segue.identifier == "CreateEntrySegue" {
            let destVC = segue.destination as! EntryDetailViewController
                destVC.entryController = entryController
        }
    }

    // MARK: - Properties
    
    let entryController = EntryController()

}
