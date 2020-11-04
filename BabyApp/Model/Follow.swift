//
//  Follow.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/30.
//

import Foundation

class Follow {
    
    var isFollow: Bool!
    var uid: String!
    var followCount: Int!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        isFollow = dict[IS_FOLLOW] as? Bool ?? false
        uid = dict[UID] as? String ?? ""
        followCount = dict[FOLLOW_COUNT] as? Int ?? 0
    }
    
    class func fetchFollows(_ userId: String, completion: @escaping(Follow) -> Void) {
        
        COLLECTION_FOLLOW.document(userId).collection(IS_FOLLOW).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if snapshot?.documents == [] {
                completion(Follow(dict: [UID: ""]))
            }
            
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let follow = Follow(dict: dict)
                completion(follow)
            })
        }
    }
    
    class func fetchFollow(_ userId: String, completion: @escaping(Follow) -> Void) {
        
        COLLECTION_FOLLOW.document(User.currentUserId()).collection(IS_FOLLOW).document(userId).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if snapshot?.data() == nil {
                completion(Follow(dict: [IS_FOLLOW: false]))
            }
            guard let dict = snapshot?.data() else { return }
            let follow = Follow(dict: dict)
            completion(follow)
        }
    }
    
    class func checkFollow(_ userId: String, completion: @escaping(Follow) -> Void) {
        
        COLLECTION_FOLLOW.document(userId).collection(IS_FOLLOW).document(User.currentUserId()).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
      
            if snapshot?.data() == nil {
                completion(Follow(dict: [IS_FOLLOW: false]))
            }
            guard let dict = snapshot?.data() else { return }
            let follow = Follow(dict: dict)
            completion(follow)
        }
    }
    
    class func fetchFollowCount(_ userId: String, completion: @escaping(Follow) -> Void) {
        
        COLLECTION_FOLLOW.document(userId).collection("follow").document("follow").getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if snapshot?.data() == nil {
                completion(Follow(dict: [FOLLOW_COUNT: 0]))
            }
            guard let dict = snapshot?.data() else { return }
            let follow = Follow(dict: dict)
            completion(follow)
        }
    }
    
    class func toFollow(userId: String, value: [String: Any], completion: @escaping() ->Void) {
        
        COLLECTION_FOLLOW.document(User.currentUserId()).collection(IS_FOLLOW).document(userId).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_FOLLOW.document(User.currentUserId()).collection(IS_FOLLOW).document(userId).updateData(value) { (_) in
                    completion()
                }
            } else {
                COLLECTION_FOLLOW.document(User.currentUserId()).collection(IS_FOLLOW).document(userId).setData(value) { (_) in
                    completion()
                }
            }
        }
    }
    
    class func unFollow(userId: String, completion: @escaping() ->Void) {
        
        COLLECTION_FOLLOW.document(User.currentUserId()).collection(IS_FOLLOW).document(userId).delete() { (_) in
            completion()
        }
    }
    
    class func updateFollowCount(value: [String: Any], completion: @escaping() ->Void) {
        
        COLLECTION_FOLLOW.document(User.currentUserId()).collection("follow").document("follow").getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_FOLLOW.document(User.currentUserId()).collection("follow").document("follow").updateData(value) { (_) in
                    completion()
                }
            } else {
                COLLECTION_FOLLOW.document(User.currentUserId()).collection("follow").document("follow").setData(value) { (_) in
                    completion()
                }
            }
        }
    }
}
