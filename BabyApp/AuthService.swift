//
//  AuthService.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import Foundation
import Firebase

struct AuthService {
    
    // MARK: - Authentication func
    
    static func loginUser(email: String, password: String, completion: @escaping(Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error == nil {
                completion(error)
            } else {
                completion(error)
            }
        }
    }
    
    static func createUser(email: String, password: String, completion: @escaping(Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error == nil {
                completion(error)
            } else {
                completion(error)
            }
        }
    }
    
    static func logoutUser(completion: @escaping(_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error as NSError {
            print("Error sign out: \(error.localizedDescription)")
            completion(error)
        }
    }
    
    static func withdrawUser(completion: @escaping(_ error: Error?) -> Void) {
        
        COLLECTION_USERS.document(User.currentUserId()).delete() { (_) in
            COLLECTION_FOLLOW.document(User.currentUserId()).delete { (_) in
                COLLECTION_FOLLOWER.document(User.currentUserId()).delete { (_) in
                    Auth.auth().currentUser?.delete(completion: { (error) in
                        
                        if error != nil {
                            print("Error withdraw user: \(error!.localizedDescription)")
                            completion(error)
                        } else {
                            UserDefaults.standard.removeObject(forKey: IS_LOGIN)
                            completion(error)
                        }
                    })
                }
            }
        }
    }
    
    
    static func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                print("error reset password: \(error!.localizedDescription)")
            }
            completion(error)
        }
    }
    
    static func changeEmail(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if let error = error {
                print("Error change email: \(error.localizedDescription)")
            } else {
                updateUser(withValue: [EMAIL: email])
            }
            completion(error)
        })
    }
    
    static func changePassword(password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            if let error = error {
                print("Error change password: \(error.localizedDescription)")
            }
            completion(error)
        })
    }
}
