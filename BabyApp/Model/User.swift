//
//  User.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import Foundation
import Firebase

class User {
    
    var uid: String!
    var username: String!
    var email: String!
    var profileImageUrl: String!
    var selfIntro: String!
    var inquiry: String!
    var opinion: String!
    var report: String!
    var appBadgeCount: Int!
    var myPageBadgeCount: Int!
    var communityBadgeCount: Int!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        username = dict[USERNAME] as? String ?? ""
        email = dict[EMAIL] as? String ?? ""
        profileImageUrl = dict[PROFILE_IMAGE_URL] as? String ?? ""
        selfIntro = dict[SELFINTRO] as? String ?? ""
        inquiry = dict[INQUIRY] as? String ?? ""
        opinion = dict[OPINION] as? String ?? ""
        report = dict[REPORT] as? String ?? ""
        appBadgeCount = dict[APP_BADGE_COUNT] as? Int ?? 0
        myPageBadgeCount = dict[MYPAGE_BADGE_COUNT] as? Int ?? 0
        communityBadgeCount = dict[COMMUNITY_BADGE_COUNT] as? Int ?? 0
    }
    
    // MARK: - Return user
    
    class func currentUserId() -> String {
        guard Auth.auth().currentUser != nil else { return "fCaTJRVce0eDLoxZAe2xLubNy893" }
        return Auth.auth().currentUser!.uid
    }
    
    // MARK: - Fetch user
    
    class func fetchUser(_ userId: String, completion: @escaping(_ user: User) -> Void) {
        
        Block.fetchBlock { (blockUserIds) in
            COLLECTION_USERS.document(userId).getDocument { (snapshot, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                if snapshot?.data() == nil {
                    completion(User(dict: [UID: ""]))
                }
                guard let dict = snapshot?.data() else { return }
                let user = User(dict: dict)
                guard blockUserIds[user.uid] == nil else { return }
                completion(user)
            }
        }
    }
    
    class func fetchBlockUser(_ userId: String, completion: @escaping(_ user: User) -> Void) {
        
        COLLECTION_USERS.document(userId).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if snapshot?.data() == nil {
                completion(User(dict: [UID: ""]))
            }
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
    
    class func fetchUsers(completion: @escaping(User) -> Void) {
        guard Auth.auth().currentUser != nil else { return }
        
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let user = User(dict: dictionary as [String: Any])
                completion(user)
            })
        }
    }
    
    class func fetchUserAddSnapshotListener(completion: @escaping(User) -> Void) {
        guard Auth.auth().currentUser != nil else { return }
        
        COLLECTION_USERS.document(User.currentUserId()).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch user add snapshot listener: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
}

// MARK: - Save

func saveUser(userId: String, withValue: [String: Any]) {
    
    COLLECTION_USERS.document(userId).setData(withValue) { (error) in
        if let error = error {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
}

func updateUser(withValue: [String: Any]) {
    
    COLLECTION_USERS.document(User.currentUserId()).updateData(withValue) { (error) in
        if let error = error {
            print("Error updating user: \(error.localizedDescription)")
        }
    }
}
