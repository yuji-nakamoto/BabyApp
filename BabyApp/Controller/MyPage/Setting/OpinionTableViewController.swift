//
//  OpinionTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/31.
//

import UIKit
import Firebase
import PKHUD

class OpinionTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var opinionLabel: UILabel!
    @IBOutlet weak var inputLabel2: UILabel!
    
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
        
        if opinionLabel.text == "ご意見・ご要望・改善等" {
            generator.notificationOccurred(.error)
            HUD.flash(.labeledError(title: "", subtitle: "内容を入力してください"), delay: 1)
            return
        }
        saveOpinion()
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
    
    private func saveOpinion() {
        
        let dict = [FROM: currentUser.uid!,
                     USERNAME: currentUser.username as Any,
                     OPINION: opinionLabel.text!,
                     TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        let dict2 = [OPINION: opinionLabel.text!,
                     TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        if Auth.auth().currentUser == nil {
            COLLECTION_OPINION.document("users").collection("opinions").addDocument(data: dict2)
            UserDefaults.standard.removeObject(forKey: OPINION)
        } else {
            COLLECTION_OPINION.document(User.currentUserId()).collection("opinions").document().setData(dict)
            updateUser(withValue: [OPINION: ""])
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
        navigationItem.title = "ご意見・ご要望・改善等"
        sendButton.layer.cornerRadius = 15
        
        if UserDefaults.standard.object(forKey: OPINION) != nil {
            let text = UserDefaults.standard.object(forKey: OPINION)
            if text as! String == "" {
                opinionLabel.text = "ご意見・ご要望・改善等"
                inputLabel2.isHidden = false
                return
            }
            opinionLabel.text = (text as! String)
            inputLabel2.isHidden = true
        } else {
            opinionLabel.text = "ご意見・ご要望・改善等"
            inputLabel2.isHidden = false
        }
    }
    
    private func setupUserInfo(_ currentUser: User) {
        
        if UserDefaults.standard.object(forKey: OPINION) != nil {
            return
        }
        
        if currentUser.opinion == nil || currentUser.opinion == "" {
            opinionLabel.text = "ご意見・ご要望・改善等"
            inputLabel2.isHidden = false
        } else {
            opinionLabel.text = currentUser.opinion
            inputLabel2.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
