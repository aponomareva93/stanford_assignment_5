//
//  Mention.swift
//  Smashtag
//
//  Created by anna on 27.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class Mention: NSManagedObject {
    static func findOrCreateMention(withKeyword keyword: String,
                                    andType type: String,
                                    andTerm searchTerm: String,
                                    in context: NSManagedObjectContext) throws -> Mention {
        let request: NSFetchRequest <Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "keyword LIKE[cd] %@ AND searchTerm =[cd] %@", keyword, searchTerm)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "mention.findOrCreateMention -- database inconsistency")
                return matches[0]
            } else {
                let mention = Mention(context: context)
                mention.count = 0
                mention.keyword = keyword.lowercased()
                mention.searchTerm = searchTerm
                mention.type = type
                return mention
            }
        } catch {
            throw error
        }
    }
    
    static func checkMention(for tweet: Tweet,
                             withKeyword keyword: String,
                             andType type: String,
                             andTerm searchTerm: String,
                             in context: NSManagedObjectContext) throws -> Mention {
        do {
            let mention = try findOrCreateMention(withKeyword: keyword, andType: type, andTerm: searchTerm, in: context)
            if let tweetSet = mention.tweets as? Set<Tweet>, !tweetSet.contains(tweet) {
                mention.addToTweets(tweet)
                mention.count = Int64(mention.count + 1)
            }
            return mention
        } catch {
            throw error
        }
    }
}
