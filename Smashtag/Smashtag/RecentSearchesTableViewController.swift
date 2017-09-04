//
//  RecentSearchesTableViewController.swift
//  Smashtag
//
//  Created by anna on 25.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class RecentSearchesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "Show Tweets",
                let vc = segue.destination as? TweetTableViewController,
                let hashtagCell = sender as? UITableViewCell {
                vc.searchText = hashtagCell.textLabel?.text
            } else if identifier == "Show Popular Mentions",
                let cell = sender as? UITableViewCell,
                let pvc = segue.destination as? PopularTableViewController {
                pvc.mention = cell.textLabel?.text
                pvc.container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
                pvc.title = "Popularity for " + (cell.textLabel?.text ?? "")
            }
        }
    }
    
    var recentSearches: [String] {
        return RecentSearches.searches
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearch", for: indexPath)
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RecentSearches.removeAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }   
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
