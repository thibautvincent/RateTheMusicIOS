//
//  SongsViewController.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 14/01/16.
//  Copyright © 2016 Thibaut Vincent. All rights reserved.
//

import UIKit

class SongsViewController : UITableViewController {
    var currentTask: NSURLSessionTask?
    var album: Album!
    var songs : [Song] = []
    
    override func viewDidLoad() {
        currentTask = Service.sharedService.getSongsService {
            [unowned self] result in switch result {
            case .Success(let songs):
                songs.forEach({ (song) -> () in
                    if song.albumId == self.album.id {
                        self.songs.append(song)
                    }
                })
                self.tableView.reloadData()
            case .Failure(let error):
                debugPrint(error)
            }
        }
        currentTask!.resume()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("songCell", forIndexPath: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel!.text = song.title
        return cell
    }

}
