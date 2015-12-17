//
//  AlbumsViewController.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 17/12/15.
//  Copyright © 2015 Thibaut Vincent. All rights reserved.
//

import UIKit

class AlbumsController : UITableViewController {
    var albums : [Album] = [];
    var currentTask: NSURLSessionTask?
    
    override func viewDidLoad() {
        currentTask = AlbumService.sharedService.getAlbums {
            [unowned self] result in switch result {
            case .Success(let albums):
                self.albums = albums
                self.tableView.reloadData()
            case .Failure(let error):
                debugPrint(error)
            }
        }
        currentTask!.resume()
    }
    
    deinit {
        currentTask?.cancel()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let lot = albums[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("albumCell", forIndexPath: indexPath)
        cell.textLabel!.text = lot.description
        return cell
    }
}
