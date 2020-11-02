//
//  CreateTweetViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit
import Firebase

class CreateTweetViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var user = User()
    private var pleaceholderLbl = UILabel()
    private var contentsImage: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTextView()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        indicator.startAnimating()
        sendButton.isEnabled = false
        saveTweet()
    }
    
    @IBAction func photoButtonPressed(_ sender: Any) {
        alertCamera()
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
        }
    }
    
    // MARK: - Helpers
    
    private func saveTweet() {
        
        let date: Double = Date().timeIntervalSince1970
        let tweetId = UUID().uuidString
        
        if contentsImage == nil {
            
            let dict = [TWEETID: tweetId,
                        UID: User.currentUserId(),
                        DATE: date,
                        TIMESTAMP: Timestamp(date: Date()),
                        TEXT: self.textView.text as Any] as [String : Any]
            
            Tweet.saveTweet(tweetId: tweetId, withValue: dict)
            Tweet.saveFeed(tweetId: tweetId, withValue: dict)
          
            indicator.stopAnimating()
            UserDefaults.standard.set(true, forKey: REFRESH)
            dismiss(animated: true, completion: nil)

        } else {
            
            contentsImageView.alpha = 0.5
            Service.uploadImage(image: contentsImage!) { [self] (imageUrl) in
                
                let dict = [TWEETID: tweetId,
                            UID: User.currentUserId(),
                            DATE: date,
                            CONTENTS_IMAGE_URL: imageUrl,
                            TIMESTAMP: Timestamp(date: Date()),
                            TEXT: textView.text as Any] as [String : Any]
            
                Tweet.saveTweet(tweetId: tweetId, withValue: dict)
                Tweet.saveFeed(tweetId: tweetId, withValue: dict)
                indicator.stopAnimating()
                contentsImageView.alpha = 1
                UserDefaults.standard.set(true, forKey: REFRESH)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func setup() {
        
        textView.becomeFirstResponder()
        sendButton.layer.cornerRadius = 10
        contentsImageView.layer.cornerRadius = 15
        sendButton.isEnabled = false
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupTextView() {
        
        textView.delegate = self
        pleaceholderLbl.isHidden = false
        
        let pleaceholderX: CGFloat = self.view.frame.size.width / 75
        let pleaceholderY: CGFloat = -10
        let pleaceholderWidth: CGFloat = textView.bounds.width - pleaceholderX
        let pleaceholderHeight: CGFloat = textView.bounds.height
        let pleaceholderFontSize = self.view.frame.size.width / 25
        
        pleaceholderLbl.frame = CGRect(x: pleaceholderX, y: pleaceholderY, width: pleaceholderWidth, height: pleaceholderHeight)
        pleaceholderLbl.text = "子育てに関すること等、投稿しよう"
        pleaceholderLbl.font = UIFont(name: "HelveticaNeue", size: pleaceholderFontSize)
        pleaceholderLbl.textColor = .systemGray4
        pleaceholderLbl.textAlignment = .left
        
        textView.addSubview(pleaceholderLbl)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 0
        } else {
            if #available(iOS 11.0, *) {
                bottomConstraint.constant = view.safeAreaInsets.bottom - keyboardViewEndFrame.height
            } else {
                bottomConstraint.constant = keyboardViewEndFrame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    private func alertCamera() {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "選択してください", preferredStyle: .actionSheet)
        let cameraAction: UIAlertAction = UIAlertAction(title: "カメラで撮影", style: .default, handler:{ [weak self]
            (action: UIAlertAction!) -> Void in
            guard let this = self else { return }
            let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = this
                cameraPicker.allowsEditing = true
                this.present(cameraPicker, animated: true, completion: nil)
            }
        })
        
        let galleryAction: UIAlertAction = UIAlertAction(title: "アルバムから選択", style: .default, handler:{ [weak self]
            (action: UIAlertAction!) -> Void in
            guard let this = self else { return }
            let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let libraryPicker = UIImagePickerController()
                libraryPicker.sourceType = sourceType
                libraryPicker.delegate = this
                libraryPicker.allowsEditing = true
                this.present(libraryPicker, animated: true, completion: nil)
            }
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("キャンセル")
        })
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate

extension CreateTweetViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let spacing = CharacterSet.whitespacesAndNewlines
        
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            pleaceholderLbl.isHidden = true
        } else {
            pleaceholderLbl.isHidden = false
        }
        
        let tweetNum = 100 - textView.text.count
        if tweetNum < 0 {
            countLabel.text = "文字数制限です"
            sendButton.isEnabled = false
        } else {
            countLabel.text = String(tweetNum)
            if textView.text == "" {
                sendButton.isEnabled = false
            } else {
                sendButton.isEnabled = true
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CreateTweetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            contentsImageView.image = selectedImage
            contentsImage = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
