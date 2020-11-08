//
//  OpinionInputViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/31.
//

import UIKit
import Firebase
import PKHUD

class OpinionInputViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    private var user: User!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveTextView()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch

    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            if UserDefaults.standard.object(forKey: OPINION) == nil {
                self.textView.text = user.opinion
            }
            self.tableView.reloadData()
        }
    }
        
    // MARK: - Helpers
    
    private func saveTextView() {
        
        if textView.text.count > 500 {
            HUD.flash(.labeledError(title: "", subtitle: "文字数制限になりました"), delay: 1)
        } else {
            if Auth.auth().currentUser == nil {
                UserDefaults.standard.set(textView.text, forKey: OPINION)
            } else {
                updateUser(withValue: [OPINION: textView.text as Any])
            }
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        navigationItem.title = "ご意見・ご要望・改善等"
        saveButton.layer.cornerRadius = 15
        backView.backgroundColor = .clear
        backView.layer .cornerRadius = 5
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.systemGray.cgColor
        tableView.separatorStyle = .none
        textView.delegate = self
        
        if UserDefaults.standard.object(forKey: OPINION) != nil {
            let text = UserDefaults.standard.object(forKey: OPINION)
            textView.text = (text as! String)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let reportNum = 500 - textView.text.count
        if reportNum < 0 {
            countLabel.text = "文字数制限です"
        } else {
            countLabel.text = String(reportNum)
        }
    }
}
