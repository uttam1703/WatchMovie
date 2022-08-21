//
//  YouTubeSearchModel.swift
//  WatchMovie
//
//  Created by uttam on 15/08/22.
//

import Foundation


struct YouTubeSearchModel:Codable{
    let items:[VideoElement]
}

struct VideoElement:Codable{
    let id:IdVideoElement
}

struct IdVideoElement:Codable{
    let kind:String
    let videoId:String
}
