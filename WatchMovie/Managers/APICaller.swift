//
//  APICaller.swift
//  WatchMovie
//
//  Created by uttam on 14/08/22.
//

import Foundation


struct APIConstant {
    /*
     Trending Movies :https://api.themoviedb.org//3/trending/movie/day?api_key=b99434bb2f057340efbf3579e1a87cc5
     Trending Tv:https://api.themoviedb.org//3/trending/tv/day?api_key=b99434bb2f057340efbf3579e1a87cc5
     Popular:https://api.themoviedb.org/3/movie/popular?api_key=b99434bb2f057340efbf3579e1a87cc5&language=hi-In&page=1
     Upcoming Movies:https://api.themoviedb.org/3/movie/upcoming?api_key=b99434bb2f057340efbf3579e1a87cc5&language=hi-In&page=1
     Top rated :https://api.themoviedb.org/3/movie/top_rated?api_key=b99434bb2f057340efbf3579e1a87cc5
     */
       static let API_KEY = "b99434bb2f057340efbf3579e1a87cc5"
       static let baseURL = "https://api.themoviedb.org"
       static let imageBaseURL="https://image.tmdb.org/t/p/w500/"
       static let YoutubeAPI_KEY = "AIzaSyC3er_2OpoztQnEt6FraKHVhp20tnWwOYU"
       static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
       static let YoutubeVideoLink="https://www.youtube.com/embed/"
}

enum APIError:Error{
    case failedFetchData
}

class APICaller{
    
    static let shared=APICaller()
    
    func getHomeMovieList(with section:SectionsName,completion:@escaping (Result<[Title],Error>)->Void){
        
        var urlString=""
        switch section{
        case .trending_movie:
            urlString="\(APIConstant.baseURL)/3/trending/movie/day?api_key=\(APIConstant.API_KEY)"
        case .trending_tv:
            urlString="\(APIConstant.baseURL)/3/trending/tv/day?api_key=\(APIConstant.API_KEY)"
        case .popular_movie:
            urlString="\(APIConstant.baseURL)/3/movie/popular?api_key=\(APIConstant.API_KEY)"
        case .upcoming_movie:
            urlString="\(APIConstant.baseURL)/3/movie/upcoming?api_key=\(APIConstant.API_KEY)"
        case .top_rated_movie:
            urlString="\(APIConstant.baseURL)/3/movie/top_rated?api_key=\(APIConstant.API_KEY)"
        case .Discover:
            urlString="\(APIConstant.baseURL)/3/discover/movie?api_key=\(APIConstant.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        default:
            urlString="\(APIConstant.baseURL)/3/trending/tv/day?api_key=\(APIConstant.API_KEY)"
        }
        
        
        guard let url=URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            
            guard let data=data, error==nil else{ return }
            do{
                let jsonData = try JSONDecoder().decode(TredingTitle.self, from: data)
                print(jsonData.results[0].title)
                completion(.success(jsonData.results))
            }catch{
                completion(.failure(APIError.failedFetchData))
            }
            
        }
        task.resume()
        
        
    }
    
    func sesrch(with query:String,completion:@escaping (Result<[Title],Error>)->Void){
        
        guard let query=query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        var urlString = "\(APIConstant.baseURL)/3/search/movie?api_key=\(APIConstant.API_KEY)&query=\(query)"
        guard let url=URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            
            guard let data=data, error==nil else{ return }
            do{
                let jsonData = try JSONDecoder().decode(TredingTitle.self, from: data)
                completion(.success(jsonData.results))
            }catch{
                completion(.failure(APIError.failedFetchData))
            }
            
        }
        task.resume()
        
        
    }
    
    func sesrchYoutube(with query:String,completion:@escaping (Result<VideoElement,Error>)->Void){
        
        guard let query=query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        var urlString = "\(APIConstant.YoutubeBaseURL)q=\(query)&maxResults=2&key=\(APIConstant.YoutubeAPI_KEY)"
        print(urlString)
        guard let url=URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            
            guard let data=data,error==nil else{
                print(error?.localizedDescription)
                return
            
            }
//            print(data)

            do{

                let jsonData = try JSONDecoder().decode(YouTubeSearchModel.self, from: data)
                print(jsonData.items.count)
                completion(.success(jsonData.items[0]))
            }catch{
                completion(.failure(APIError.failedFetchData))
            }
            
        }
        task.resume()
        
        
    }
    
    
}
