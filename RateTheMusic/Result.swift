//
//  Result.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 17/12/15.
//  Copyright © 2015 Thibaut Vincent. All rights reserved.
//

enum Result<T>{
    case Success(T)
    case Failure(AlbumService.Error)
}