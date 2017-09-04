//
//  ImageCollectionViewCell.swift
//  Smashtag
//
//  Created by anna on 26.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    var cache: Cache?
    
    var tweetMedia: TweetMedia? {
        didSet {
            guard let url = tweetMedia?.media.url else {
                return
            }
            spinner?.startAnimating()
            if let imageData = cache?[url] {
                spinner?.stopAnimating()
                imageView.image = UIImage(data: imageData)
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                if url == self?.tweetMedia?.media.url,
                    let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.sync {
                        self?.imageView.image = UIImage(data: imageData)
                        
                        self?.cache?[url] = imageData
                        self?.spinner.stopAnimating()
                    }
                }
            }
        }
    }
}
