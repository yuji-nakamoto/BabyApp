//
//  RegisterViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit

import UIKit
import JGProgressHUD
import TextFieldEffects

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    
    private let emailTextField = HoshiTextField(frame: CGRect(x: 40, y: 200, width: 300, height: 60))
    private let passwordTextField = HoshiTextField(frame: CGRect(x: 40, y: 265, width: 300, height: 60))
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        doneButton.isEnabled = true
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        hud.textLabel.text = ""
        hud.show(in: view)
        if textFieldHaveText() {
            createUser()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    // MARK: - User
    
    private func createUser() {
        
        AuthService.createUser(email: emailTextField.text!, password: passwordTextField.text!) { [self] (error) in
            if error != nil {
                generator.notificationOccurred(.error)
                hud.textLabel.text = "既に登録されているアドレスか、アドレスが無効です"
                hud.dismiss(afterDelay: 2.0)
                return
            }
            hud.textLabel.text = "登録が完了しました"
            hud.dismiss(afterDelay: 3.0)
            saveUser(userId: User.currentUserId(), withValue: [UID: User.currentUserId(), EMAIL: emailTextField.text as Any])
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                view.endEditing(true)
                toEnterNameVC()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        emailTextField.placeholderColor = .systemBlue
        emailTextField.borderActiveColor = UIColor(named: O_RED)
        emailTextField.borderInactiveColor = .systemBlue
        emailTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        emailTextField.placeholder = "メールアドレス"
        emailTextField.keyboardType = .emailAddress
        self.view.addSubview(emailTextField)
        
        passwordTextField.placeholderColor = .systemBlue
        passwordTextField.borderActiveColor = UIColor(named: O_RED)
        passwordTextField.borderInactiveColor = .systemBlue
        passwordTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "パスワード"
        self.view.addSubview(passwordTextField)
        
        descriptionLabel.text = "メールアドレスとパスワードを入力して、アカウントを作成してください。"
        doneButton.layer.cornerRadius = 44 / 2
        dismissButton.layer.cornerRadius = 44 / 2
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.systemBlue.cgColor
        termsButton.layer.cornerRadius = 44 / 2
        termsButton.layer.borderWidth = 1
        termsButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func textFieldHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    // MARK: - Navigation
    
    private func toEnterNameVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let enterNameVC = storyboard.instantiateViewController(withIdentifier: "EnterNameVC")
        self.present(enterNameVC, animated: true, completion: nil)
    }
}
