//
//  LoginViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/30.
//

import UIKit
import PKHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var passwordLineView: UIView!
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailLIneHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordLineHeight: NSLayoutConstraint!
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Actions    
    
    @IBAction func dismissButtonPreseed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        loginButton.isEnabled = false
        if textFieldHaveText() {
            loginUser()
        } else {
            generator.notificationOccurred(.error)
            HUD.flash(.labeledError(title: "", subtitle: "入力欄を全て埋めてください"), delay: 1)
            loginButton.isEnabled = true
        }
    }
    
    // MARK: - User
    
    private func loginUser() {
        
        AuthService.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { [self] (error) in
            if error == nil {
                HUD.flash(.labeledSuccess(title: "", subtitle: "ログインしました"), delay: 2)
                self.toTabBerVC()
            } else {
                HUD.flash(.labeledError(title: "", subtitle: "メールアドレス、もしくはパスワードが間違えています"), delay: 1)
                loginButton.isEnabled = true
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setup() {
        
        descriptionlabel.text = "メールアドレスとパスワードを\n入力してください。"
        loginButton.layer.cornerRadius = 44 / 2
        dismissButton.layer.cornerRadius = 44 / 2
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(emailTextFieldTap), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldTap), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailLabelDown), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(passwordLabelDown), for: .editingDidEnd)
    }
    
    @objc func emailTextFieldTap() {
        emailTopConstraint.constant = 20
        emailLIneHeight.constant = 2
        emailLineView.backgroundColor = UIColor(named: O_RED)
    }
    
    @objc func passwordTextFieldTap() {
        passwordTopConstraint.constant = 20
        passwordLineHeight.constant = 2
        passwordLineView.backgroundColor = UIColor(named: O_RED)
    }
    
    @objc func emailLabelDown() {
        if emailTextField.text == "" {
            emailTopConstraint.constant = 40
            emailLIneHeight.constant = 1
            emailLineView.backgroundColor = UIColor.systemBlue
        }
    }
    
    @objc func passwordLabelDown() {
        if passwordTextField.text == "" {
            passwordTopConstraint.constant = 40
            passwordLineHeight.constant = 1
            passwordLineView.backgroundColor = UIColor.systemBlue
        }
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            UserDefaults.standard.set(true, forKey: IS_LOGIN)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toTabBerVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
            self.present(toTabBerVC, animated: true, completion: nil)
        }
    }
}
