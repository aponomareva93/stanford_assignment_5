//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by anna on 27.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SmashTweetTableViewController: TweetTableViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        if searchText != nil {
            updateDatabase(with: newTweets)
        }
    }
    
    private func updateDatabase(with tweets:[Twitter.Tweet]) {
        container?.performBackgroundTask( {
            [weak self] context in
            /*for twitterInfo in tweets {
                _ = try? Tweet.findTweetAndCheckMentions(for: twitterInfo, with: (self?.searchText)!, in: context)
            }*/
            try? Tweet.newTweets(for: tweets, with: (self?.searchText)!, in: context)
            try? context.save()
            self?.printDatabaseStatistics()
        })
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if let tweetCount = (try? context.fetch(Tweet.fetchRequest()))?.count {
                    print("\(tweetCount) tweets")
                }
                if let mentionsCount = try? context.count(for: Mention.fetchRequest()) {
                    print("\(mentionsCount) mentions")
                }
            }
        }
    }
}
