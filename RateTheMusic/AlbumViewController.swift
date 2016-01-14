//
//  AlbumViewController.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 22/12/15.
//  Copyright © 2015 Thibaut Vincent. All rights reserved.
//

import UIKit



class AlbumViewController: UITableViewController {
    @IBOutlet weak var coverImage : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var artistLabel : UILabel!
    @IBOutlet weak var releasedLabel : UILabel!
    @IBOutlet weak var genreLabel : UILabel!
    @IBOutlet weak var descriptionTextView : UITextView!
    
    var album: Album!
    
    override func viewDidLoad() {
        if let url = NSURL(string: album.cover) {
            if let data = NSData(contentsOfURL: url) {
                coverImage.image = UIImage(data: data)
            }
        }
        titleLabel!.text = album.albumtitle
        artistLabel!.text = album.artist
        releasedLabel!.text = album.released_at
        genreLabel!.text = album.genre
        descriptionTextView!.text = album.description
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let songController = (segue.destinationViewController as! UINavigationController).topViewController as! SongsViewController
        songController.album = self.album
    }
}
