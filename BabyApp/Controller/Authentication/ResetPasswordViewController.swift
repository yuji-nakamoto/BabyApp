//
//  ResetPasswordViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/30.
//

import UIKit
import JGProgressHUD
import TextFieldEffects

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailLIneHeight: NSLayoutConstraint!
    
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        hud.textLabel.text = ""
        hud.show(in: self.view)
        if textFieldHaveText() {
            
            sendButton.isEnabled = false
            resetPassword()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "メールアドレスを入力してください"
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func resetPassword() {
        
        AuthService.resetPassword(email: emailTextField.text!) { (error) in
            
            if error != nil {
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = "登録されていないメールアドレスか、メールアドレスが無効です"
                self.hud.dismiss(afterDelay: 2.0)
                return
            }
            self.hud.textLabel.text = "リセットメールを送信しました"
            self.hud.dismiss(afterDelay: 2.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func setupUI() {
        
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.addTarget(self, action: #selector(emailTextFieldTap), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailLabelDown), for: .editingDidEnd)
        
        descriptionLabel.text = "リセットメールを送信後、届いたメールに記載しているURLを開いて、新しいパスワードを登録してください。"
        sendButton.isEnabled = true
        sendButton.layer.cornerRadius = 44 / 2
        backButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc func emailTextFieldTap() {
        emailTopConstraint.constant = 20
        emailLIneHeight.constant = 2
        emailLineView.backgroundColor = UIColor(named: O_RED)
    }
    
    @objc func emailLabelDown() {
        if emailTextField.text == "" {
            emailTopConstraint.constant = 40
            emailLIneHeight.constant = 1
            emailLineView.backgroundColor = UIColor.systemBlue
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func textFieldHaveText() -> Bool {
        return emailTextField.text != ""
    }
}
