//
//  Follower.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/30.
//

import Foundation

class Follower {
    
    var isFollower: Bool!
    var uid: String!
    var followerCount: Int!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        isFollower = dict[IS_FOLLOWER] as? Bool ?? false
        uid = dict[UID] as? String ?? ""
        followerCount = dict[FOLLOWER_COUNT] as? Int ?? 0
    }
    
    class func fetchFollowers(_ userId: String, completion: @escaping(Follower) -> Void) {
        
        COLLECTION_FOLLOWER.document(userId).collection(IS_FOLLOWER).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if snapshot?.documents == [] {
                completion(Follower(dict: [UID: ""]))
            }
            
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let follower = Follower(dict: dict)
                completion(follower)
            })
        }
    }
    
    class func fetchFollower(_ userId: String, completion: @escaping(Follower) -> Void) {
        
        COLLECTION_FOLLOWER.document(User.currentUserId()).collection(IS_FOLLOWER).document(userId).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if snapshot?.data() == nil {
                completion(Follower(dict: [IS_FOLLOWER: false]))
            }
            guard let dict = snapshot?.data() else { return }
            let follower = Follower(dict: dict)
            completion(follower)
        }
    }
    
    class func fetchFollowerCount(_ userId: String, completion: @escaping(Follower) -> Void) {
        
        COLLECTION_FOLLOWER.document(userId).collection("follower").document("follower").getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if snapshot?.data() == nil {
                completion(Follower(dict: [FOLLOWER_COUNT: 0]))
            }
            guard let dict = snapshot?.data() else { return }
            let follower = Follower(dict: dict)
            completion(follower)
        }
    }
    
    class func toFollower(userId: String, value: [String: Any], completion: @escaping() ->Void) {
        
        COLLECTION_FOLLOWER.document(userId).collection(IS_FOLLOWER).document(User.currentUserId()).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_FOLLOWER.document(userId).collection(IS_FOLLOWER).document(User.currentUserId()).updateData(value) { (_) in
                    completion()
                }
            } else {
                COLLECTION_FOLLOWER.document(userId).collection(IS_FOLLOWER).document(User.currentUserId()).setData(value) { (_) in
                    completion()
                }
            }
        }
    }
    
    class func unFollower(userId: String, completion: @escaping() ->Void) {
        
        COLLECTION_FOLLOWER.document(userId).collection(IS_FOLLOWER).document(User.currentUserId()).delete() { (_) in
            completion()
        }
    }
    
    class func updateFollowerCount(userId: String, value: [String: Any], completion: @escaping() ->Void) {
        
        COLLECTION_FOLLOWER.document(userId).collection("follower").document("follower").getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_FOLLOWER.document(userId).collection("follower").document("follower").updateData(value) { (_) in
                    completion()
                }
            } else {
                COLLECTION_FOLLOWER.document(userId).collection("follower").document("follower").setData(value) { (_) in
                    completion()
                }
            }
        }
    }
}
