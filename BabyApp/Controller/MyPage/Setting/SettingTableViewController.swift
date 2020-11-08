//
//  SettingTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/31.
//

import UIKit
import Firebase
import PKHUD

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var followSwitch: UISwitch!
    @IBOutlet weak var postSwitch: UISwitch!
    
    private var user = User()
    private var profileImage: UIImage?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func completionButtonPressed(_ sender: Any) {
        
        if nameTextField.text!.count > 10 {
            HUD.flash(.labeledError(title: "", subtitle: "名前は10文字以下で入力してください"), delay: 2)
            return
        }
        
        if textView.text!.count > 200 {
            HUD.flash(.labeledError(title: "", subtitle: "自己紹介は200文字以下で入力してください"), delay: 2)
            return
        }
    
        let dict = [USERNAME: nameTextField.text,
                    SELFINTRO: textView.text]
        
        updateUser(withValue: dict as [String : Any])
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFollowSwich(_ sender: UISwitch) {
        guard User.currentUserId() != "" else { return }
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: PUSH_FOLLOW)
            Messaging.messaging().subscribe(toTopic: "follow\(User.currentUserId())")
            followLabel.text = "フォロー通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: PUSH_FOLLOW)
            Messaging.messaging().unsubscribe(fromTopic: "follow\(User.currentUserId())")
            followLabel.text = "フォロー通知を受信しない"
        }
    }
    
    @IBAction func onPostSwich(_ sender: UISwitch) {
        guard User.currentUserId() != "" else { return }

        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: PUSH_POST)
            Messaging.messaging().subscribe(toTopic: "post\(User.currentUserId())")
            postLabel.text = "投稿通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: PUSH_POST)
            Messaging.messaging().unsubscribe(fromTopic: "post\(User.currentUserId())")
            postLabel.text = "投稿通知を受信しない"
        }
    }
    
    @objc func tapProfileImage() {
        
        if UserDefaults.standard.object(forKey: IS_LOGIN) == nil {
            HUD.flash(.labeledError(title: "", subtitle: "プロフィール編集を行うにはログインが必要です"), delay: 1)
            return
        }
        alertCamera()
    }
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.setupUserInfo(self.user)
        }
    }
    
    // MARK: - Helpers
    
    private func setup() {
        
        if UserDefaults.standard.object(forKey: IS_LOGIN) != nil {
            loginButton.isEnabled = false
            nameTextField.isHidden = false
            textView.isHidden = false
            logoutLabel.alpha = 1
        } else {
            loginButton.isEnabled = true
            nameTextField.isHidden = true
            textView.isHidden = true
            logoutLabel.alpha = 0.5
        }
        
        if UserDefaults.standard.object(forKey: PUSH_FOLLOW) != nil {
            followSwitch.isOn = true
            followLabel.text = "フォロー通知を受信する"
        } else {
            followSwitch.isOn = false
            followLabel.text = "フォロー通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: PUSH_POST) != nil {
            postSwitch.isOn = true
            postLabel.text = "投稿通知を受信する"
        } else {
            postSwitch.isOn = false
            postLabel.text = "投稿通知を受信しない"
        }
                
        textView.delegate = self
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        navigationItem.title = "設定"
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapProfileImage))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.layer.cornerRadius = 100 / 2
    }
    
    private func setupUserInfo(_ user: User) {
        
        nameTextField.text = user.username
        nameTextField.textColor = .systemBlue
        if user.profileImageUrl != "" {
            profileImageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        } else {
            profileImageView.image = UIImage(named: "placeholder-image")
        }
        textView.text = user.selfIntro
        let count = 200 - user.selfIntro.count
        countLabel.text = String(count)
    }
        
    private func alertCamera() {
        
        let alert = UIAlertController(title: "", message: "選択してください", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default, handler:{ [weak self]
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
        
        let galleryAction = UIAlertAction(title: "アルバムから選択", style: .default, handler:{ [weak self]
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
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel)
        let screenSize = UIScreen.main.bounds
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 4 {
            
            if UserDefaults.standard.object(forKey: IS_LOGIN) == nil {
                return
            }
            let alert = UIAlertController(title: "", message: "ログアウトしますか？", preferredStyle: .actionSheet)
            let loguout = UIAlertAction(title: "ログアウトする", style: UIAlertAction.Style.default) { (alert) in
                AuthService.logoutUser { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    UserDefaults.standard.removeObject(forKey: IS_LOGIN)
                    UserDefaults.standard.removeObject(forKey: PUSH_POST)
                    UserDefaults.standard.removeObject(forKey: PUSH_FOLLOW)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
                    self.present(tabVC, animated: true, completion: nil)
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            let screenSize = UIScreen.main.bounds
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
            alert.addAction(loguout)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
        }
    }
}

// MARK: - UITextViewDelegate

extension SettingTableViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let introNum = 200 - textView.text.count
        if introNum < 0 {
            countLabel.text = "文字数制限"
        } else {
            countLabel.text = String(introNum)
        }
    }
}

extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            profileImageView.image = selectedImage
            profileImage = selectedImage
            indicator.startAnimating()
            profileImageView.alpha = 0.5
            Service.uploadImage(image: profileImage!) { [self] (imageUrl) in
                updateUser(withValue: [PROFILE_IMAGE_URL: imageUrl])
                profileImageView.alpha = 1
                indicator.stopAnimating()
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
