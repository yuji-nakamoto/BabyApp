//
//  Config.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/03.
//

import Foundation

let serverKey = "AAAA_Rz6s2Y:APA91bEL_Vljn0uLBFE3c7p8OdAVxU8l_BdqOeatSBokKVVqlzDnv1kvY-3agunP2F-z6XLWLwgkQvqEsLcXUJtB7I1Ts0vWXtURGdlFMgt89jakNKkXIH7SAb8aLf1ZZvJKB9aemBeQ"
let fcmUrl = "https://fcm.googleapis.com/fcm/send"

func sendRequestNotification(userId: String, message: String, badge: Int) {
    
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let notification: [String: Any] = [ "to": "/topics/follow\(userId)",
        "notification": ["title": "フォロー",
                          "body": message,
                          "badge": badge,
                          "sound": "default"]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HttpUrlResponse \(httpResponse.statusCode)")
            print("Response \(String(describing: response))")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
    }.resume()
}

func sendRequestNotification2(userId: String, message: String, badge: Int) {
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let notification: [String: Any] = [ "to": "/topics/post\(userId)",
        "notification": ["title": "投稿",
                          "body": message,
                          "badge": badge,
                          "sound": "default",
                          "content-available": true]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HttpUrlResponse \(httpResponse.statusCode)")
            print("Response \(String(describing: response))")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
    }.resume()
}
