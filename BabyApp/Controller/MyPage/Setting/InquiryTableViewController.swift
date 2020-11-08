//
//  InquiryTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/31.
//

import UIKit
import Firebase
import PKHUD

class InquiryTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var inquiryLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailLIneHeight: NSLayoutConstraint!
    
    private var currentUser = User()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        fetchCurrentUser()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if inquiryLabel.text == "お問い合わせ内容" {
            generator.notificationOccurred(.error)
            HUD.flash(.labeledError(title: "", subtitle: "内容を入力してください"), delay: 1)
            return
        }
        
        if emailTextField.text == "" {
            generator.notificationOccurred(.error)
            HUD.flash(.labeledError(title: "", subtitle: "メールアドレスを入力してください"), delay: 1)
            return
        }
        saveInquiry()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            self.setupUserInfo(self.currentUser)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func saveInquiry() {
        
        let dict = [FROM: currentUser.uid!,
                    USERNAME: currentUser.username as Any,
                    EMAIL: emailTextField.text!,
                    INQUIRY: inquiryLabel.text!,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        let dict2 = [EMAIL: emailTextField.text!,
                    INQUIRY: inquiryLabel.text!,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        if Auth.auth().currentUser == nil {
            COLLECTION_INQUIRY.document("users").collection("inquiries").addDocument(data: dict2)
            UserDefaults.standard.removeObject(forKey: INQUIRY)
        } else {
            COLLECTION_INQUIRY.document(User.currentUserId()).collection("inquiries").document().setData(dict)
            updateUser(withValue: [INQUIRY: ""])
        }

        HUD.flash(.labeledSuccess(title: "", subtitle: "送信が完了しました"), delay: 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setup() {
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        navigationItem.title = "お問い合わせ"
        sendButton.layer.cornerRadius = 15
        
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(emailTextFieldTap), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailLabelDown), for: .editingDidEnd)
        emailTextField.keyboardType = .emailAddress
        
        if UserDefaults.standard.object(forKey: INQUIRY) != nil {
            let text = UserDefaults.standard.object(forKey: INQUIRY)
            if text as! String == "" {
                inquiryLabel.text = "お問い合わせ内容"
                inputLabel.isHidden = false
                return
            }
            inquiryLabel.text = (text as! String)
            inputLabel.isHidden = true
        } else {
            inquiryLabel.text = "お問い合わせ内容"
            inputLabel.isHidden = false
        }
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
    
    private func setupUserInfo(_ currentUser: User) {
        
        if UserDefaults.standard.object(forKey: INQUIRY) != nil {
            return
        }
        
        emailTextField.text = currentUser.email
        if currentUser.inquiry == nil || currentUser.inquiry == "" {
            inquiryLabel.text = "お問い合わせ内容"
            inputLabel.isHidden = false
        } else {
            inquiryLabel.text = currentUser.inquiry
            inputLabel.isHidden = true
        }
        
        if emailTextField.text == "" {
            emailTopConstraint.constant = 40
            emailLIneHeight.constant = 1
            emailLineView.backgroundColor = UIColor.systemBlue
        } else {
            emailTopConstraint.constant = 20
            emailLIneHeight.constant = 2
            emailLineView.backgroundColor = UIColor(named: O_RED)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
