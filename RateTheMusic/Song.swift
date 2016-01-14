//
//  Song.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 17/12/15.
//  Copyright © 2015 Thibaut Vincent. All rights reserved.
//

import Foundation

class Song {
    let id: String
    let title: String
    let albumId: String
    
    init(id: String, title: String, albumId: String) {
        self.id = id
        self.title = title
        self.albumId = albumId
    }
}