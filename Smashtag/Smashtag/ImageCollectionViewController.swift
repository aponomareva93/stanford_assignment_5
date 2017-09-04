//
//  ImageCollectionViewController.swift
//  Smashtag
//
//  Created by anna on 26.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit
import Twitter

private let reuseIdentifier = "Image Cell"

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var tweets: [[Twitter.Tweet]] = [] {
        didSet {
            images = tweets.flatMap({$0}).map {
                    tweet in
                    tweet.media.map { TweetMedia(tweet: tweet, media: $0) }
                }.flatMap({$0})
        }
    }
    
    private var images: [TweetMedia] = []
    
    private var cache = Cache()
    
    private struct FlowLayout {
        static let minImageCellWidth: CGFloat = 60
        static let columnCount: CGFloat = 3
        static let minimumColumnSpacing: CGFloat = 2
        static let minimumInteritemSpacing: CGFloat = 2
        static let sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    var predefinedWidth: CGFloat {
        return floor(((collectionView?.bounds.width)! - FlowLayout.minimumColumnSpacing * (FlowLayout.columnCount - 1.0) - FlowLayout.sectionInset.right * 2.0) / FlowLayout.columnCount)
    }
    
    var sizePredefined: CGSize {
        return CGSize(width: predefinedWidth, height: predefinedWidth)
    }
    
    var scale: CGFloat = 1 {
        didSet {
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    func zoom(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:))))
        installsStandardGestureForInteractiveMovement = true
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier) 
    }
    
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = images[destinationIndexPath.row]
        images[destinationIndexPath.row] = images[sourceIndexPath.row]
        images[sourceIndexPath.row] = temp
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Tweet",
            let tvc = segue.destination as? TweetTableViewController,
            let cell = sender as? ImageCollectionViewCell,
            let tweetMedia = cell.tweetMedia {
            tvc.newTweets = [tweetMedia.tweet]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = CGFloat(images[indexPath.row].media.aspectRatio)
        var sizeSetting = sizePredefined
        if let layoutFlow = collectionViewLayout as? UICollectionViewFlowLayout {
            let maxCellWidth = collectionView.bounds.size.width - layoutFlow.minimumInteritemSpacing * 2.0 - layoutFlow.sectionInset.right * 2.0
            sizeSetting = layoutFlow.itemSize
            let size = CGSize(width: sizeSetting.width * scale, height: sizeSetting.height * scale)
            let cellWidth = min(max(size.width, FlowLayout.minImageCellWidth), maxCellWidth)
            return CGSize(width: cellWidth, height: cellWidth / ratio)
        }
        return CGSize(width:sizeSetting.width * scale, height: sizeSetting.height * scale)
    }
    
    private func setupLayout() {
        let layoutFlow = UICollectionViewFlowLayout()
        
        layoutFlow.minimumInteritemSpacing = FlowLayout.minimumInteritemSpacing
        layoutFlow.minimumLineSpacing = FlowLayout.minimumColumnSpacing
        layoutFlow.sectionInset = FlowLayout.sectionInset
        layoutFlow.itemSize = sizePredefined
        collectionView?.collectionViewLayout = layoutFlow
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.cache = cache
            imageCell.tweetMedia = images[indexPath.row]
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

public struct TweetMedia: CustomStringConvertible {
    var tweet: Twitter.Tweet
    var media: MediaItem
    
    public var description: String { return "\(tweet): \(media)" }
}

