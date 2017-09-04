//
//  PopularTableViewController.swift
//  Smashtag
//
//  Created by anna on 27.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit
import CoreData

class PopularTableViewController: FetchedResultsTableViewController {

    var mention: String? {
        didSet {
            updateUI()
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet {
            updateUI()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<Mention>?
    
    private func updateUI() {
        if let context = container?.viewContext, mention != nil {
            let request: NSFetchRequest<Mention> = Mention.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(
                    key: "type",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ),
                NSSortDescriptor (
                    key: "count",
                    ascending: false
                ),
                NSSortDescriptor(
                    key: "keyword",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            
            request.predicate = NSPredicate(format: "count > 1 AND searchTerm = %@", mention!)
            fetchedResultsController = NSFetchedResultsController<Mention>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "type",
                cacheName: nil)
        }
        try? fetchedResultsController?.performFetch()
        fetchedResultsController?.delegate = self
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUserCell", for: indexPath)
        
        if let mention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = mention.keyword
            let mentionsCount = mention.count
            cell.detailTextLabel?.text = "\(mentionsCount) tweet\((mentionsCount != 1) ? "s" : "")"
        }
        return cell
    }
}
