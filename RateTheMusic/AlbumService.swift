//
//  AlbumService.swift
//  RateTheMusic
//
//  Created by Thibaut Vincent on 17/12/15.
//  Copyright © 2015 Thibaut Vincent. All rights reserved.
//

import Foundation




class AlbumService {
    
    enum Error: ErrorType {
        case MissingData
        case InvalidJsonData
        case MissingJsonProperty(name: String)
        case NetworkError(message: String?)
        case UnexpectedStatusCode(code: Int)
    }
    
    static let sharedService = AlbumService();
    
    private let url : NSURL
    private let session : NSURLSession
    
    init(){
        let propertiesPath = NSBundle.mainBundle().pathForResource("apilinks", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        let baseUrl = properties["baseUrl"] as! String
        url = NSURL(string: baseUrl)!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }
    
    func getAlbums(completionHandler: (Result<[Album]>) -> Void) -> NSURLSessionTask {
        return session.dataTaskWithURL(url) {
            data, response, error in
            debugPrint("test")
            
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
                let json =  try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions()) as! NSDictionary
                guard let albums = json[""] as? [NSDictionary] else {
                    completionHandler(.Failure(.MissingJsonProperty(name: "albums")))
                    return
                }
            
            let results = try json.map { try Album(json: $0) }
                completionHandler(.Success(results))
            } catch _ as NSError{
                completionHandler(.Failure(.InvalidJsonData))
            } catch let error as Error {
                completionHandler(.Failure(error))
            }
        }
    }
}