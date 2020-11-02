//
//  WithdrawViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/31.
//

import UIKit
import JGProgressHUD
import Firebase
import TextFieldEffects

class WithdrawViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var hud = JGProgressHUD(style: .dark)
    private var user = User()
    private let emailTextField = HoshiTextField(frame: CGRect(x: 40, y: 170, width: 300, height: 60))
    private let passwordTextField = HoshiTextField(frame: CGRect(x: 40, y: 230, width: 300, height: 60))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        doneButton.isEnabled = false
        hud.textLabel.text = ""
        hud.show(in: self.view)
        if textFieldHaveText() {
            withdrawUser()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください"
            hud.dismiss(afterDelay: 2.0)
            doneButton.isEnabled = true
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Withdraw
    
    private func withdrawUser() {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        let credential = EmailAuthProvider.credential(withEmail: email!, password: password!)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print("Error reauth: \(error.localizedDescription)")
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = "メールアドレス、もしくはパスワードが間違えています"
                self.hud.dismiss(afterDelay: 3.0)
                self.doneButton.isEnabled = true
            } else {
                AuthService.withdrawUser { (error) in
                    if let error = error {
                        print("Error withdraw: \(error.localizedDescription)")
                    } else {
                        self.hud.textLabel.text = "アカウントを削除しました"
                        self.hud.dismiss(afterDelay: 3.0)
                        self.toTabVC()
                        self.doneButton.isEnabled = true
                    }
                }
            }
        })
    }
    
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
        
        doneButton.layer.cornerRadius = 44 / 2
        backButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        descriptionlabel.text = "メールアドレスとパスワードを\n入力してください"
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
    
    private func toTabVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
            self.present(tabVC, animated: true, completion: nil)
        }
    }
}
