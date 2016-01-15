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
    var songs:[String] = []
    
    init(id: String, albumtitle: String, artist: String, released_at: String, genre: String, cover: String, description: String, songs:[String]){
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