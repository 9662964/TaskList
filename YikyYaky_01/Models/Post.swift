//
//  Post.swift
//  YikyYaky_01
//
//  Created by iljoo Chae on 7/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import CloudKit

struct PostStrings {
    static let recordTypeKey = "post"
    static let textKey = "text"
    static let authorKey = "author"
    static let timestampKey = "timestamp"
    static let scoreKey = "score"
}


//1
class Post {
    
    let text: String
    let author: String
    let timestamp: Date
    var score: Int
    
    let recordID: CKRecord.ID
   //2
    init(text: String, author: String, timestamp: Date = Date(), score: Int = 0, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.author = author
        self.timestamp = timestamp
        self.score = score
        self.recordID = recordID
    }
    
}//End of Class

//3
extension Post {
    //failable so able to return nil
    convenience init?(ckRecord: CKRecord) {
        //taking CKRecord and tell you what is what in the post
        guard let text = ckRecord[PostStrings.textKey] as? String,
            let author = ckRecord[PostStrings.authorKey] as? String,
            let timestamp = ckRecord[PostStrings.timestampKey] as? Date,
            let score = ckRecord[PostStrings.scoreKey] as? Int else {return nil}
        
        self.init(text: text, author: author, timestamp: timestamp, score: score, recordID: ckRecord.recordID)
        
    }
}//End of Extension



//4
extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType:PostStrings.recordTypeKey, recordID: post.recordID)
        
        self.setValuesForKeys([
            PostStrings.textKey: post.text,
            PostStrings.authorKey: post.author,
            PostStrings.timestampKey: post.timestamp,
            PostStrings.scoreKey: post.score
        ])
    }
    
}//End of Extension

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
    
}
