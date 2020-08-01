//
//  PostController.swift
//  YikyYaky_01
//
//  Created by iljoo Chae on 7/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import CloudKit

class PostController {
    //MARK: - Properties
    static let sharedInstance = PostController()
    var posts: [Post] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    //MARK: - Method
    //Create - being able to write down function signature
    func createPost(text: String, author: String, completion: @escaping (Result<Bool, YYError>) -> Void  ) {
        
        let newPost = Post(text: text, author: author)
        let newPostRecord = CKRecord(post: newPost)
        
        publicDB.save(newPostRecord) { (record, error) in
            if let error = error {
                print("There was an error -- \(error) -  \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                let savedPost = Post(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            
            //add to SOT
            self.posts.append(savedPost)
            completion(.success(true))
        }
    }
    
    func fetchAllPosts(completion: @escaping (Result<Bool,YYError>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: PostStrings.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("error - \(error)  --\(error.localizedDescription)")
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.couldNotUnwrap))}
            
            let posts: [Post] = records.compactMap{ Post(ckRecord:$0) }
            self.posts = posts
            completion(.success(true))
        }
    }
    
    func updatePost(post: Post, completion: @escaping (Result<Post,YYError>) -> Void) {
        
        //1
        let record = CKRecord(post: post)
        //2
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        //3
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {(records,_,error) in
            if let error = error {
                print("error \(error) --\(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            //records.first because of array, first element of array
            guard let record = records?.first,
                let updatedPost = Post(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            
            print("Successfully updated the record with ID:\(updatedPost.recordID)")
            completion(.success(updatedPost))
        }
        publicDB.add(operation)
    }
    func deletePost(post: Post, completion: @escaping (Result<Bool,YYError>)-> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [post.recordID])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {(records,_,error) in
            if let error = error {
                print("error \(error) -\(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            if records?.count == 0 {
                print("Successfully deleted records from CloudKit")
                completion(.success(true))
            }else{
                return completion(.failure(.unableToDeleteRecord))
            }
            
        }
        publicDB.add(operation)
        
    }
    
}//End Of Class
