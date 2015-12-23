//
//  AlbumService.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 17/12/15.
//  Copyright © 2015 Thibaut Vincent. All rights reserved.
//

import Foundation


class Service {
    
    enum Error: ErrorType {
        case MissingData
        case InvalidJsonData
        case MissingJsonProperty(name: String)
        case NetworkError(message: String?)
        case UnexpectedStatusCode(code: Int)
    }
    
    
    static let sharedService = Service();
     var url: NSURL
     var session: NSURLSession
    
    
     var albums: [Album] = []
     var songs: [Song] = []

    init(){
        
    }
    
    func getSongs(completionHandler: (Result<[Song]>) -> Void) -> NSURLSessionTask {
        let propertiesPath = NSBundle.mainBundle().pathForResource("apilinks", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        var baseUrl = properties["songsUrl"] as! String
        baseUrl += ""
        url = NSURL(string: baseUrl)!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        return session.dataTaskWithURL(url) {
            data, response, error in
            
            let completionHandler: Result<[Song]> -> Void = {
                result in
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(result)
                }
            }
            
            
            guard let response = response as? NSHTTPURLResponse else {
                completionHandler(.Failure(.NetworkError(message: error?.description)))
                return
            }
            
            guard response.statusCode == 200 else {
                
                completionHandler(.Failure(.UnexpectedStatusCode(code: response.statusCode)))
                return
            }
            
            guard let data = data else {
                
                completionHandler(.Failure(.MissingData))
                return
            }
            do {
                let json =  try NSJSONSerialization.JSONObjectWithData(data, options:
                    NSJSONReadingOptions.MutableContainers) as! [Dictionary<String,AnyObject>]
                for album in json {
                    let id = album["_id"] as! String
                    let title = album["albumtitle"] as! String
                    let artist = album["artist"] as! String
                    let released_at = album["released_at"] as! String
                    let genre = album["genre"] as! String
                    let cover = album["cover"] as! String
                    let description = album["description"] as! String
                    let songs = album["songs"] as! [Song]
                    let newAlbum = Album(id: id, albumtitle: title, artist: artist, released_at: released_at, genre: genre, cover: cover, description: description, songs: songs)
                    self.albums.append(newAlbum)
                }
                
                completionHandler(.Success(self.songs))
                
            } catch _ as NSError{
                completionHandler(.Failure(.InvalidJsonData))
            } catch let error as Error {
                completionHandler(.Failure(error))
            }
        }
        
    }
    
    func getAlbums(completionHandler: (Result<[Album]>) -> Void) -> NSURLSessionTask {
        let propertiesPath = NSBundle.mainBundle().pathForResource("apilinks", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        let baseUrl = properties["baseUrl"] as! String
        url = NSURL(string: baseUrl)!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        return session.dataTaskWithURL(url) {
            data, response, error in
            
            let completionHandler: Result<[Album]> -> Void = {
                result in
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(result)
                }
            }
            
            
            guard let response = response as? NSHTTPURLResponse else {
                completionHandler(.Failure(.NetworkError(message: error?.description)))
                return
            }
            
            guard response.statusCode == 200 else {
                
                completionHandler(.Failure(.UnexpectedStatusCode(code: response.statusCode)))
                return
            }
            
            guard let data = data else {
                
                completionHandler(.Failure(.MissingData))
                return
            }
            do {
                let json =  try NSJSONSerialization.JSONObjectWithData(data, options:
                    NSJSONReadingOptions.MutableContainers) as! [Dictionary<String,AnyObject>]
                for album in json {
                    let id = album["_id"] as! String
                    let title = album["albumtitle"] as! String
                    let artist = album["artist"] as! String
                    let released_at = album["released_at"] as! String
                    let genre = album["genre"] as! String
                    let cover = album["cover"] as! String
                    let description = album["description"] as! String
                    let songs = album["songs"] as! [Song]
                    let newAlbum = Album(id: id, albumtitle: title, artist: artist, released_at: released_at, genre: genre, cover: cover, description: description, songs: songs)
                    self.albums.append(newAlbum)
                }
                
                completionHandler(.Success(self.albums))
                
            } catch _ as NSError{
                completionHandler(.Failure(.InvalidJsonData))
            } catch let error as Error {
                completionHandler(.Failure(error))
            }
        }
        
        
    }
}