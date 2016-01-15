//
//  AlbumsViewController.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 17/12/15.
//  Copyright © 2015 Thibaut Vincent. All rights reserved.
//  Searchtool from http://www.raywenderlich.com/113772/uisearchcontroller-tutorial

import UIKit

class AlbumsViewController : UITableViewController,UISplitViewControllerDelegate {
    var currentTask: NSURLSessionTask?
    var albums : [Album] = []
    var results : [Album] = []
    let searchController = UISearchController(searchResultsController: nil)
    let refreshCtrl = UIRefreshControl()
    
    override func viewDidLoad() {
        loadAlbums()
        currentTask!.resume()
        splitViewController!.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        refreshCtrl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshCtrl)
        
    }
    
    deinit {
        currentTask?.cancel()
    }
    
    func loadAlbums(){
        currentTask = Service.sharedService.getAlbums {
            [unowned self] result in switch result {
            case .Success(let albums):
                self.albums = albums
                self.tableView.reloadData()
            case .Failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func isActive() -> Bool {
        if searchController.active && searchController.searchBar.text != "" {
            return true;
        }
        return false
    }
    
    func handleRefresh(sender: AnyObject) {
        self.albums.removeAll()
        loadAlbums()
        currentTask!.resume()
        self.refreshCtrl.endRefreshing()
        tableView.reloadData()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isActive() {
            return results.count
        }
        return albums.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("albumCell", forIndexPath: indexPath)
        let album : Album
        if isActive() {
            album = results[indexPath.row]
        } else {
            album = albums[indexPath.row]
        }
        cell.textLabel!.text = album.albumtitle
        cell.detailTextLabel!.text = album.artist
        return cell
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let album : Album
        let detailController = (segue.destinationViewController as! UINavigationController).topViewController as! AlbumViewController
        // if isActive() {
          //   album = results[tableView.indexPathForSelectedRow!.row]
        //}else {
             album = albums[tableView.indexPathForSelectedRow!.row]
        //}
        detailController.album = album
    }
    
    func filterContentForSearchText(searchText: String){
        self.results = self.albums.filter{ album in
            return album.albumtitle.lowercaseString.containsString(searchText.lowercaseString) || album.artist.lowercaseString.containsString((searchText.lowercaseString))
        }
        tableView.reloadData()
        }
    }

    extension AlbumsViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
