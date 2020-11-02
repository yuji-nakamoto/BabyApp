//
//  Service.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import Foundation
import FirebaseStorage
import Firebase

struct Service {
    
    // MARK: - Load image
    
    static func uploadImage(image: UIImage, completion: @escaping(_ imageUrl: String) -> Void) {
        
        var task: StorageUploadTask!
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let filename = NSUUID().uuidString
        let withPath = "/images/\(filename)"
        let storageRef = Storage.storage().reference(forURL: "gs://babyapp-a1e0b.appspot.com").child(withPath)
        
        task = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            
            task.removeAllObservers()
            
            if let error = error {
                print("DEBUG: Error uploading image: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
