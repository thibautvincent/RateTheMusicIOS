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
    
    private let url: NSURL
    private let session: NSURLSession
    var albums: [Album] = []
    var songs: [Song] = []
    
    init(){
         let propertiesPath = NSBundle.mainBundle().pathForResource("apilinks", ofType: "plist")!
         let properties = NSDictionary(contentsOfFile: propertiesPath)!
         let baseUrl = properties["baseUrl"] as! String
         url = NSURL(string: baseUrl)!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())

    }
    
    func getSongsService(completionHandler: (Result<[Song]>) -> Void) -> NSURLSessionTask{
        self.songs.removeAll()
        let songsLink = "https://ratethemusic.herokuapp.com/api/songs"
        let songsUrl = NSURL(string: songsLink)!
        let songsSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        return songsSession.dataTaskWithURL(songsUrl) {
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
                for song in json {
                    let id = song["_id"] as! String
                    let title = song["title"] as! String
                    let albumId = song["album"] as! String
                    let newSong = Song(id: id, title: title, albumId: albumId)
                    self.songs.append(newSong)
                }
            } catch _ as NSError{
                print("Invalid Jsondata")
            } catch let error as Error {
                print(error)
            }
            completionHandler(.Success(self.songs))
            
            
        }
    }
    
    func getAlbums(completionHandler: (Result<[Album]>) -> Void) -> NSURLSessionTask {
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
            self.albums.removeAll()
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
                    let songs = album["songs"] as! [String]
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