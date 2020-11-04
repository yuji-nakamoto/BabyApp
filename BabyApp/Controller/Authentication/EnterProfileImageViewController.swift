//
//  EnterProfileImageViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit

import UIKit
import JGProgressHUD

class EnterProfileImageViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var anyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    private let picker = UIImagePickerController()
    private var profileImage: UIImage?
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nextButton.isEnabled = true
        skipButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        hud.textLabel.text = ""
        hud.show(in: self.view)
        if profileImage == nil {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "プロフィール画像を設定してください"
            hud.dismiss(afterDelay: 2.0)
            return
        }
        nextButton.isEnabled = false
        skipButton.isEnabled = false
        saveProfileImage()
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        addPlaceholederImage()
        skipButton.isEnabled = false
        nextButton.isEnabled = false
    }
    
    @IBAction func profileImageTaped(_ sender: Any) {
        alertCamera()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save
    
    private func saveProfileImage() {
        
        Service.uploadImage(image: profileImage!) { [self] (imageUrl) in
            
            let dict = [PROFILE_IMAGE_URL: imageUrl,
                        SELFINTRO: "はじめまして、こんにちは😊"]
            
            updateUser(withValue: dict)
            toTabVC()
        }
    }
    
    private func addPlaceholederImage() {
        
        let dict = [PROFILE_IMAGE_URL: PLACEHOLDER_IMAGE_URL,
                    SELFINTRO: "はじめまして、こんにちは😊"]
        
        updateUser(withValue: dict)
        toTabVC()
    }
    
    // MARK: - Helpers
    
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
    
    private func setupUI() {
        
        picker.delegate = self
        anyLabel.layer.borderWidth = 1
        anyLabel.layer.borderColor = UIColor.systemGray3.cgColor
        descriptionLabel.text = "プロフィール画像を設定してください。\nあとで設定する場合はスキップを押してください。"
        nextButton.layer.cornerRadius = 44 / 2
        skipButton.layer.cornerRadius = 44 / 2
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = UIColor.systemBlue.cgColor
        backButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.systemBlue.cgColor
        profileImageView.layer.cornerRadius = 150 / 2
    }
    
    // MARK: - Navigation

    private func toTabVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            hud.dismiss()
            UserDefaults.standard.set(true, forKey: IS_LOGIN)
            UserDefaults.standard.set(true, forKey: PUSH_POST)
            UserDefaults.standard.set(true, forKey: PUSH_FOLLOW)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
            self.present(tabVC, animated: true, completion: nil)
        }
    }
}

extension EnterProfileImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            profileImageView.image = selectedImage
            profileImage = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
