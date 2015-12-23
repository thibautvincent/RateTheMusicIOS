//
//  Album.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 17/12/15.
//  Copyright © 2015 Thibaut Vincent. All rights reserved.
//

import Foundation

class Album {
    let id: String
    let albumtitle: String
    let artist: String
    let released_at: String
    let genre: String
    let cover: String
    let description: String
    var songs:[Song] = []
    
    init(id: String, albumtitle: String, artist: String, released_at: String, genre: String, cover: String, description: String, songs:[Song]){
        self.id = id
        self.albumtitle = albumtitle
        self.artist = artist
        self.released_at = released_at
        self.genre = genre
        self.cover = cover
        self.description = description
        self.songs = songs
    }
}

//extension Album: CustomStringConvertible {}
//
//extension Album {
//    convenience init(json: NSDictionary) throws {
//        guard let id = json["albumtitle"] as? String else{
//            throw AlbumService.Error.MissingJsonProperty(name: "id")
//        }
//        guard let albumtitle = json["albumtitle"] as? String else{
//            throw AlbumService.Error.MissingJsonProperty(name: "albumtitle")
//        }
//        guard let artist = json["artist"] as? String else{
//            throw AlbumService.Error.MissingJsonProperty(name: "artist")
//        }
//        guard let released_at = json["released_at"] as? String else{
//            throw AlbumService.Error.MissingJsonProperty(name: "released_at")
//        }
//        guard let genre = json["genre"] as? String else{
//            throw AlbumService.Error.MissingJsonProperty(name: "genre")
//        }
//        guard let cover = json["cover"] as? String else{
//            throw AlbumService.Error.MissingJsonProperty(name: "cover")
//        }
//        guard let description = json["description"] as? String else{
//            throw AlbumService.Error.MissingJsonProperty(name: "description")
//        }
//        guard let songs = json["songs"] as? [Song] else{
//            throw AlbumService.Error.MissingJsonProperty(name: "songs")
//        }
//        guard let upvotes = json["upvotes"] as? [Upvote] else{
//            throw AlbumService.Error.MissingJsonProperty(name: "upvotes")
//        }
//        guard let comments = json["comments"] as? [Comment] else{
//            throw AlbumService.Error.MissingJsonProperty(name: "comments")
//        }
//        self.init(id: id, albumtitle: albumtitle, artist: artist, released_at: released_at, genre: genre, cover: cover, description: description, songs: songs, upvotes: upvotes, comments: comments)
//    }
//}