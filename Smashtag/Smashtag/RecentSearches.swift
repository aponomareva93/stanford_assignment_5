//
//  RecentSearches.swift
//  Smashtag
//
//  Created by anna on 25.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

struct RecentSearches {
    private static let userDefaults = UserDefaults.standard
    private static let key = "RecentSearches"
    private static let searchesCount = 100
    
    static var searches: [String] {
        return (userDefaults.object(forKey: key) as? [String]) ?? []
    }
    
    static func add(_ item: String) {
        if item.isEmpty {
            return
        }
        var searchesArray = searches.filter({item.caseInsensitiveCompare($0) != .orderedSame})
        searchesArray.insert(item, at: 0)
        while searchesArray.count > searchesCount {
            searchesArray.removeLast()
        }
        userDefaults.set(searchesArray, forKey: key)
    }
    
    static func removeAtIndex(_ index: Int) {
        var searchesArray = userDefaults.object(forKey: key) as? [String] ?? []
        searchesArray.remove(at: index)
        userDefaults.set(searchesArray, forKey: key)
    }
}
