//
//  BlockListTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/01.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class BlockListTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    private var users = [User]()
    private var blockUsers = [Block]()
    private var block = Block()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        fetchBlockUser()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchBlockUser() {
        
        users.removeAll()
        blockUsers.removeAll()
        
        Block.fetchBlockUsers { [self] (block) in
            if block.uid == "" {
                tableView.reloadData()
                return
            }
            self.block = block
            
            if self.block.isBlock == 0 {
                return
            } else if self.block.isBlock == 1 {
                
                self.fetchUser(uid: self.block.uid) {
                    self.blockUsers.append(block)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func fetchUser(uid: String, completion: @escaping() -> Void) {
        
        User.fetchBlockUser(uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "OtherVC" {
            let otherVC = segue.destination as! OtherViewController
            let userId = sender as! String
            otherVC.userId = userId
        }
    }
    
    // MARK: - Helpers
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/6418139939"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setup() {
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        navigationItem.title = "ブロック"
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .systemGray2
    }
}

// MARK: - Table view

extension BlockListTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FollowTableViewCell

        cell.blockListVC = self
        cell.block = blockUsers[indexPath.row]
        cell.configureBlockCell(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OtherVC", sender: blockUsers[indexPath.row].uid)
    }
}

extension BlockListTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "ブロックしたお相手はいません", attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "プロフィール画面右側の\nボタンからブロックができます", attributes: attributes)
    }
}
