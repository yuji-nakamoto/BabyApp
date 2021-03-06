//
//  FollowerTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/30.
//

import UIKit
import EmptyDataSet_Swift
import GoogleMobileAds

class FollowerTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var followerArray = [Follower]()
    private var users = [User]()
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        fetchFollowers()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchFollowers() {
        
        users.removeAll()
        followerArray.removeAll()
        indicator.startAnimating()
        
        if userId == "" {
            userId = User.currentUserId()
        }
        Follower.fetchFollowers(userId) { [self] (follower) in
            if follower.uid == "" {
                indicator.stopAnimating()
                return
            }
            fetchUser(follower.uid) {
                followerArray.append(follower)
                indicator.stopAnimating()
                tableView.reloadData()
            }
        }
    }
    
    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        User.fetchUser(uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    // MARK: - Helpers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "OtherVC" {
            let otherVC = segue.destination as! OtherViewController
            let userId = sender as! String
            otherVC.userId = userId
        }
    }
    
    private func setup() {
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.separatorColor = .systemGray
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        navigationItem.title = "フォロワー"
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/6418139939"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

// MARK: - Table view

extension FollowerTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FollowTableViewCell
        
        cell.followerVC = self
        cell.user = users[indexPath.row]
        cell.configureCell(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let uid = users[indexPath.row].uid {
            if uid != User.currentUserId() {
                performSegue(withIdentifier: "OtherVC", sender: uid)
            }
        }
    }
}

extension FollowerTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "フォロワーはいません", attributes: attributes)
    }
}
