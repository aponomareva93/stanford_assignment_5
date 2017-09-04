//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by anna on 25.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {

    @IBAction func toRootViewController(_ sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    var tweet: Twitter.Tweet? {
        didSet {
            guard let tweet = tweet else {
                return
            }
            title = tweet.user.screenName
            mentionSections = initMentionSections(from: tweet)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "Search Mentions",
                let vc = segue.destination as? TweetTableViewController,
                let mentionCell = sender as? UITableViewCell,
                var text = mentionCell.textLabel?.text {
                if text.hasPrefix("@") {
                    text += " OR from:" + text
                }
                vc.searchText = text
            } else if identifier == "Show Image" {
                if let vc = segue.destination as? ImageViewController,
                    let imageCell = sender as? ImageTableViewCell {
                    vc.image = imageCell.tweetImage.image
                    vc.title = title
                }
            } else if identifier == "Show URL" {
                if let wvc = segue.destination as? WebViewController,
                let cell = sender as? UITableViewCell,
                    let url = cell.textLabel?.text {
                    wvc.URL = URL(string: url)
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Search Mentions",
            let mentionCell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: mentionCell),
            mentionSections[indexPath.section].type == "URLs" {
            performSegue(withIdentifier: "Show URL", sender: sender)
            return false
            /*if let urlString = mentionCell.textLabel?.text {
                let url = URL(string: urlString)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
                return false
            }*/
        }
        return true
    }

    // MARK: - Table view data source
    private var mentionSections: [MentionSection] = []
    
    private struct MentionSection {
        var type: String
        var mentions: [MentionItem]
    }
    
    private enum MentionItem {
        case keyword(String)
        case image(URL, Double)
    }
    
    private func initMentionSections(from tweet:Twitter.Tweet) -> [MentionSection] {
        if tweet.media.count > 0 {
            mentionSections.append(MentionSection(type: "Images", mentions: tweet.media.map{ MentionItem.image($0.url, $0.aspectRatio) }))
        }
        if tweet.urls.count > 0 {
            mentionSections.append(MentionSection(type: "URLs", mentions: tweet.urls.map{ MentionItem.keyword($0.keyword) }))
        }
        if tweet.hashtags.count > 0 {
            mentionSections.append(MentionSection(type: "Hashtags", mentions: tweet.hashtags.map{ MentionItem.keyword($0.keyword) }))
        }
        
        var userItems = [MentionItem]()
        userItems += [MentionItem.keyword("@" + tweet.user.screenName)]
        
        if tweet.userMentions.count > 0 {
            userItems += tweet.userMentions.map { MentionItem.keyword($0.keyword) }
        }
        if userItems.count > 0 {
            mentionSections.append(MentionSection(type:"Users", mentions: userItems))
        }
        return mentionSections
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentionSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionSections[section].mentions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        
        switch mention {
        case .keyword(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Keyword Cell", for: indexPath)
            cell.textLabel?.text = keyword
            return cell
        case .image(let URL, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Image Cell", for: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.imageURL = URL
            }
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        switch mention {
        case .image(_, let aspectRatio):
            return tableView.bounds.size.width / CGFloat(aspectRatio)
        case .keyword(_):
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentionSections[section].type
    }

}
