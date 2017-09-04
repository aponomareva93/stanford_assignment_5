//
//  File.swift
//  Smashtag
//
//  Created by anna on 26.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

class Cache: NSCache<NSURL, NSData> {
    subscript(key: URL) -> Data? {
        get {
            return object(forKey: key as NSURL) as Data?
        }
        set {
            if let data = newValue {
                setObject(data as NSData, forKey: key as NSURL, cost: data.count / 1024)
            } else {
                removeObject(forKey: key as NSURL)
            }
        }
    }
}
