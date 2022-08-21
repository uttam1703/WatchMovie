//
//  Title.swift
//  WatchMovie
//
//  Created by uttam on 14/08/22.
//

import Foundation

//For both Tv and Movie
struct Title:Codable{
    let id:Int
    let title:String? //Movie Title
    let name:String? // Tv series  name
    let overview:String?
    let poster_path:String?
    let release_date:String?
    let vote_count:Int?
    let media_type:String?
    
}

struct TredingTitle:Codable{
    let results:[Title]
}


/*
 
 "adult": false,
 "backdrop_path": "/qpH6z1e4Lm9O4vWClSfDzSxPnqd.jpg",
 "id": 755566,
 "title": "Day Shift",
 "original_language": "en",
 "original_title": "Day Shift",
 "overview": "An LA vampire hunter has a week to come up with the cash to pay for his kid's tuition and braces. Trying to make a living these days just might kill him.",
 "poster_path": "/bI7lGR5HuYlENlp11brKUAaPHuO.jpg",
 "media_type": "movie",
 "genre_ids": [
 28,
 14,
 27
 ],
 "popularity": 248.993,
 "release_date": "2022-08-10",
 "video": false,
 "vote_average": 6.796,
 "vote_count": 113
 */
