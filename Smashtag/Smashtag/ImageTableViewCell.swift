//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by anna on 25.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImage: UIImageView!
    
    var imageURL: URL? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.tweetImage?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}
