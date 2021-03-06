//
//  ReportTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/01.
//

import UIKit
import Firebase
import PKHUD

class ReportTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var userId = ""
    private var user = User()
    private var currentUser = User()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        fetchCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if reportLabel.text == "通報内容" {
            HUD.flash(.labeledError(title: "", subtitle: "通報内容を入力してください"), delay: 1)
            return
        }
        saveReport()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            self.tableView.reloadData()
        }
    }
    
    private func fetchUser() {
        guard userId != "" else { return }
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
        }
        
        User.fetchUser(userId) { (user) in
            self.user = user
            self.setupUserInfo(user, self.currentUser)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func saveReport() {
        
        let dict = [FROM: currentUser.uid!,
                    TO: user.uid!,
                    "fromEmail": currentUser.email!,
                    "toEmail": user.email!,
                    REPORT: reportLabel.text!,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_REPORT.document(User.currentUserId()).collection("reports").document().setData(dict) { (error) in
            if let error = error {
                print("Error save report: \(error.localizedDescription)")
            }
            updateUser(withValue: [REPORT: ""])
            HUD.flash(.labeledSuccess(title: "", subtitle: "送信が完了しました"), delay: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func setup() {
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        navigationItem.title = "通報"
        nameLabel.text = ""
        profileImageView.layer.cornerRadius = 80 / 2
        sendButton.layer.cornerRadius = 15
    }
    
    private func setupUserInfo(_ user: User, _ currentUser: User) {
        
        nameLabel.text = user.username
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        
        if currentUser.report == "" || currentUser.report == nil {
            reportLabel.text = "通報内容"
            inputLabel.isHidden = false
        } else {
            reportLabel.text = currentUser.report
            inputLabel.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
