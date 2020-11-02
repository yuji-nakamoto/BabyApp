//
//  Tweet.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import Foundation
import Firebase

class Tweet {
    
    var contentsImageUrl: String!
    var text: String!
    var date: Double!
    var date2: Double!
    var timestamp: Timestamp!
    var tweetId: String!
    var uid: String!
    var likeCount: Int!
    var comment: String!
    var commentCount: Int!
    var commentId: String!

    init() {
    }
    
    init(dict: [String: Any]) {
        contentsImageUrl = dict[CONTENTS_IMAGE_URL] as? String ?? ""
        text = dict[TEXT] as? String ?? ""
        tweetId = dict[TWEETID] as? String ?? ""
        date = dict[DATE] as? Double ?? 0
        date2 = dict[DATE2] as? Double ?? 0
        timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
        uid = dict[UID] as? String ?? ""
        likeCount = dict[LIKECOUNT] as? Int ?? 0
        comment = dict[COMMENT] as? String ?? ""
        commentCount = dict[COMMENTCOUNT] as? Int ?? 0
        commentId = dict[COMMENTID] as? String ?? ""
    }
    
    class func fetchTweets(completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_TWEET.order(by: TIMESTAMP, descending: true).getDocuments { (snapshot, error) in
            
            if let error = error {
                print("Error fetch tweets: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(Tweet(dict: [UID: ""]))
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let tweet = Tweet(dict: dict)
                completion(tweet)
            })
        }
    }
    
    class func fetchTweet(tweetId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch tweet: \(error.localizedDescription)")
            }
            if snapshot?.data() == nil {
                completion(Tweet(dict: [TWEETID: ""]))
            }
            guard let dict = snapshot?.data() else { return }
            let tweet = Tweet(dict: dict)
            completion(tweet)
        }
    }
    
    class func fetchTweetComments(tweetId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).collection("comments").order(by: DATE, descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch tweet comment: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(Tweet(dict: [UID: ""]))
            }
            snapshot?.documents.forEach({ (documents) in
                let dict = documents.data()
                let tweetComment = Tweet(dict: dict)
                completion(tweetComment)
            })
        }
    }
    
    class func fetchTweetCommentCount(tweetId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch tweet comment: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let tweetComment = Tweet(dict: dict)
            completion(tweetComment)
        }
    }
    
    class func fetchMyTweet(_ userId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_FEED.document(userId).collection("feed").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let myTweet = Tweet(dict: dict)
                completion(myTweet)
            })
        }
    }
    
    class func fetchFeed(_ userId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_FEED.document(userId).collection("feed").order(by: TIMESTAMP, descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let feed = Tweet(dict: dict)
                completion(feed)
            })
        }
    }

    class func checkIsLikeTweet(tweetId: String, completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    class func checkIsLikeComment(tweetId: String, commentId: String, completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
  
    class func saveTweetComment(tweetId: String, commentId: String, withValue: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).setData(withValue)
    }
    
    class func saveTweet(tweetId: String, withValue: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).setData(withValue)
    }
    
    class func saveFeed(tweetId: String, withValue: [String: Any]) {
        COLLECTION_FEED.document(User.currentUserId()).collection("feed").document(tweetId).setData(withValue)
    }
    
    class func updateIsLikeTweet(tweetId: String, value1: [String: Any], value2: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).updateData(value1)
        
        COLLECTION_TWEET.document(tweetId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_TWEET.document(tweetId).collection("isLike").document("isLike").updateData(value2)
            } else {
                COLLECTION_TWEET.document(tweetId).collection("isLike").document("isLike").setData(value2)
            }
        }
    }
    
    class func updateOtherLikeCount(userId: String, tweetId: String, value: [String: Any]) {
        COLLECTION_FEED.document(userId).collection("feed").document(tweetId).updateData(value)
    }
    
    class func updateIsLikeComment(tweetId: String, commentId: String, value1: [String: Any], value2: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).updateData(value1)
        
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike").document("isLike").updateData(value2)
            } else {
                COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike").document("isLike").setData(value2)
            }
        }
    }
    
    class func updateCommentCount(tweetId: String, withValue: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).updateData(withValue)
    }
    
    class func deleteTweet(tweetId: String) {
        COLLECTION_TWEET.document(tweetId).delete()
        COLLECTION_FEED.document(User.currentUserId()).collection("feed").document(tweetId).delete()
    }
    
    class func deleteComment(tweetId: String, commentId: String) {
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).delete()
    }
}
