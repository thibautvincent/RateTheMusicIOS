//
//  AlbumsViewController.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 17/12/15.
//  Copyright © 2015 Thibaut Vincent. All rights reserved.
//

import UIKit

class AlbumsViewController : UITableViewController,UISplitViewControllerDelegate {
    var currentTask: NSURLSessionTask?
    var albums : [Album] = []
    
    override func viewDidLoad() {
       currentTask = Service.sharedService.getAlbums {
            [unowned self] result in switch result {
                
            case .Success(let albums):
                self.albums = albums
                self.tableView.reloadData()
            case .Failure(let error):
                debugPrint(error)
            }

        }
        currentTask!.resume()
        splitViewController!.delegate = self

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
        cell.textLabel!.text = lot.albumtitle
        cell.detailTextLabel!.text = lot.artist
        return cell
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailController = (segue.destinationViewController as! UINavigationController).topViewController as! AlbumViewController
        let album = albums[tableView.indexPathForSelectedRow!.row]
        detailController.album = album
    }
}
