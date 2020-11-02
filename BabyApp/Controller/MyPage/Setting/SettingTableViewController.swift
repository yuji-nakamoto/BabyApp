//
//  SettingTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/31.
//

import UIKit
import JGProgressHUD

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    private var user = User()
    private var profileImage: UIImage?
    private var hud = JGProgressHUD(style: .dark)
        
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
            hud.textLabel.text = "名前は10文字以下で入力してください"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: view)
            hud.dismiss(afterDelay: 1.5)
            return
        }
        
        if textView.text!.count > 200 {
            hud.textLabel.text = "自己紹介は200文字以下で入力してください"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: view)
            hud.dismiss(afterDelay: 1.5)
            return
        }
    
        let dict = [USERNAME: nameTextField.text,
                    SELFINTRO: textView.text]
        
        updateUser(withValue: dict as [String : Any])
        UserDefaults.standard.set(true, forKey: REFRESH)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapProfileImage() {
        
        if UserDefaults.standard.object(forKey: IS_LOGIN) == nil {
            hud.textLabel.text = "プロフィール編集を行うにはログインが必要です"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: view)
            hud.dismiss(afterDelay: 1.5)
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
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func withdraw() {
        
        let alert = UIAlertController(title: "", message: "退会手続きを進めますか？\n※退会するとアカウント情報が削除されます", preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: "退会を進める", style: UIAlertAction.Style.default) { (alert) in
            self.toWithdrawVC()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(logout)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    private func toWithdrawVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toWithdrawVC = storyboard.instantiateViewController(withIdentifier: "WithdrawVC")
        self.present(toWithdrawVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 3 {
            
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
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
                    self.present(tabVC, animated: true, completion: nil)
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(loguout)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.section == 2 && indexPath.row == 4 {
            withdraw()
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
