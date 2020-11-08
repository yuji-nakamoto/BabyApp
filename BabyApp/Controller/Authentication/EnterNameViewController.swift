//
//  EnterNameViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit

import UIKit
import PKHUD

class EnterNameViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLineView: UIView!
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLIneHeight: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextButton.isEnabled = true
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if textFieldHaveText() {
            
            if nameTextField.text!.count > 10 {
                generator.notificationOccurred(.error)
                HUD.flash(.labeledError(title: "", subtitle: "10文字以下で入力してください"), delay: 1)
            } else {
                nextButton.isEnabled = false
                updateUser(withValue: [USERNAME: nameLabel.text as Any])
                toEnterProfileImageVC()
            }
            
        } else {
            generator.notificationOccurred(.error)
            HUD.flash(.labeledError(title: "", subtitle: "名前を入力してください"), delay: 1)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        nameTextField.addTarget(self, action: #selector(nameTextFieldTap), for: .editingDidBegin)
        nameTextField.addTarget(self, action: #selector(nameLabelDown), for: .editingDidEnd)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nameTextField.keyboardType = .emailAddress
        
        nameLabel.text = "-"
        requiredLabel.layer.borderWidth = 1
        requiredLabel.layer.borderColor = UIColor.systemBlue.cgColor
        descriptionLabel.text = "ニックネームを10文字以下で入力してください。\nニックネームはあとで変更することができます。"
        nextButton.layer.cornerRadius = 44 / 2
    }
    
    @objc func nameTextFieldTap() {
        nameTopConstraint.constant = 20
        nameLIneHeight.constant = 2
        nameLineView.backgroundColor = UIColor(named: O_RED)
    }
    
    @objc func nameLabelDown() {
        if nameTextField.text == "" {
            nameTopConstraint.constant = 40
            nameLIneHeight.constant = 1
            nameLineView.backgroundColor = UIColor.systemBlue
        }
    }
    
    @objc func textFieldDidChange() {
        
        nameLabel.text = nameTextField.text
        
        let nicknameNum = 10 - nameTextField.text!.count
        if nicknameNum < 0 {
            countLabel.text = "×"
        } else {
            countLabel.text = String(nicknameNum)
        }
    }
    
    private func textFieldHaveText() -> Bool {
        return nameTextField.text != ""
    }
    
    // MARK: - Navigation
    
    private func toEnterProfileImageVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterProfileImageVC = storyboard.instantiateViewController(withIdentifier: "EnterProfileImageVC")
            self.present(toEnterProfileImageVC, animated: true, completion: nil)
        }
    }
}
