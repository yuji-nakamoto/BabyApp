//
//  BlockTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/01.
//

import UIKit
import JGProgressHUD

class BlockTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    
    var userId = ""
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func blockButtonPressed(_ sender: Any) {
        saveBlock()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        guard userId != "" else { return }
        
        User.fetchUser(userId) { (user) in
            self.user = user
            self.setupUserInfo(user)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func saveBlock() {
        
        Block.saveBlock(userId: userId)
        hud.textLabel.text = "ブロックしました"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
        UserDefaults.standard.set(true, forKey: REFRESH)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setup() {
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        navigationItem.title = "ブロック"
        nameLabel.text = ""
        profileImageView.layer.cornerRadius = 80 / 2
        blockButton.layer.cornerRadius = 15
    }
    
    private func setupUserInfo(_ user: User) {
        
        nameLabel.text = user.username
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
