//
//  LoginViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/30.
//

import UIKit
import JGProgressHUD
import TextFieldEffects

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    private var hud = JGProgressHUD(style: .dark)
    private let emailTextField = HoshiTextField(frame: CGRect(x: 40, y: 190, width: 300, height: 60))
    private let passwordTextField = HoshiTextField(frame: CGRect(x: 40, y: 250, width: 300, height: 60))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions    
    
    @IBAction func dismissButtonPreseed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        hud.textLabel.text = ""
        hud.show(in: self.view)
        if textFieldHaveText() {
            loginUser()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください"
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    // MARK: - User
    
    private func loginUser() {
        
        AuthService.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error == nil {
                self.hud.textLabel.text = "ログインしました"
                self.hud.dismiss(afterDelay: 2.0)
                self.toTabBerVC()

            } else {
                self.hud.textLabel.text = "メールアドレス、もしくはパスワードが間違えています"
                self.hud.dismiss(afterDelay: 2.0)
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
        
        descriptionlabel.text = "メールアドレスとパスワードを\n入力してください。"
        loginButton.layer.cornerRadius = 44 / 2
        dismissButton.layer.cornerRadius = 44 / 2
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.systemBlue.cgColor
        
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
    
    private func toTabBerVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            hud.dismiss()
            UserDefaults.standard.set(true, forKey: IS_LOGIN)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toTabBerVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
            self.present(toTabBerVC, animated: true, completion: nil)
        }
    }
}
