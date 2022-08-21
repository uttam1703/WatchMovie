//
//  CoreDataManger.swift
//  WatchMovie
//
//  Created by uttam on 16/08/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataManger{
    
    
    static let shared=CoreDataManger()
    
    
    enum DatabaseError:Error{
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    
    
    //create
    public func downloadTitle(with model:Title,completion:@escaping(Result<Void,Error>)->Void){
        
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {return}
        let context=appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        item.id=Int64(model.id)
        item.poster_path=model.poster_path
        item.name=model.name
        item.title=model.title
        item.release_date=model.release_date
        item.overview=model.overview
        item.vote_count=Int64(model.vote_count ?? 4)
        item.media_type=model.media_type


        
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToFetchData))

        }
    }
    
    //read
    public func readDownloadData(completion:@escaping(Result<[TitleItem],Error>)->Void){
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {return}
        let context=appDelegate.persistentContainer.viewContext

        let request:NSFetchRequest<TitleItem>=TitleItem.fetchRequest()
        do{
//            try context.save()
            let titles=try context.fetch(request)
            completion(.success(titles))
        }catch{
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToSaveData))

        }

    }
    
    
    //delete
    public func deleteDownloadData(model:TitleItem,completion:@escaping(Result<Void,Error>)->Void){
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {return}
        let context=appDelegate.persistentContainer.viewContext

        context.delete(model)
        do{
            try context.save()
            completion(.success(()))
        }catch{
            
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToDeleteData))
        }

        
    }
    
}
