//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by anna on 24.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    let mensionColors: Dictionary<String, UIColor> = [
        "hashtag": UIColor.orange,
        "url": UIColor.cyan,
        "userName": UIColor.green
    ]
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func setColoredText (_ tweet: Twitter.Tweet?) -> NSMutableAttributedString {
        guard let currentTweet = tweet else {
            return NSMutableAttributedString()
        }
        
        let attributedText = NSMutableAttributedString(string: currentTweet.text)
        for hashtag in currentTweet.hashtags {
            attributedText.addAttribute(NSForegroundColorAttributeName, value: mensionColors["hashtag"] ?? UIColor.black, range: hashtag.nsrange)
        }
        for url in currentTweet.urls {
            attributedText.addAttribute(NSForegroundColorAttributeName, value: mensionColors["url"] ?? UIColor.black, range: url.nsrange)
        }
        for userName in currentTweet.userMentions {
            attributedText.addAttribute(NSForegroundColorAttributeName, value: mensionColors["userName"] ?? UIColor.black, range: userName.nsrange)
        }
        return attributedText
    }
    
    private func setProfileImageView(_ tweet: Twitter.Tweet?) {
        tweetProfileImageView?.image = nil
        guard let tweet = tweet, let profileImageURL = tweet.user.profileImageURL else {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            let contentsOfURL = try? Data(contentsOf: profileImageURL)
            if profileImageURL == tweet.user.profileImageURL, let imageData = contentsOfURL {
                DispatchQueue.main.async {
                    self?.tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    private func updateUI() {
        tweetTextLabel?.attributedText = setColoredText(tweet)
        tweetUserLabel?.text = tweet?.user.description
        
        setProfileImageView(tweet)
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}
