//
//  ParchmentCommunityViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import Parchment

class ParchmentCommunityViewController: UIViewController {
    
    private var statusBarStyle: UIStatusBarStyle = .lightContent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    func setStatusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tweetVC = storyboard.instantiateViewController(withIdentifier: "TweetVC")
        let feedVC = storyboard.instantiateViewController(withIdentifier: "FeedVC")
        
        tweetVC.title = "みんなの投稿"
        feedVC.title = "フィード"
        
        let pagingVC = PagingViewController(viewControllers: [tweetVC, feedVC])
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 51)
        ])
        
        pagingVC.font = UIFont(name: "HiraMaruProN-W4", size: 12)!
        pagingVC.selectedFont = UIFont(name: "HiraMaruProN-W4", size: 14)!
        pagingVC.selectedTextColor = .white
        pagingVC.textColor = .white
        pagingVC.indicatorColor = .systemYellow
        pagingVC.menuItemSize = .fixed(width: 130, height: 40)
        pagingVC.menuHorizontalAlignment = .center
        pagingVC.menuBackgroundColor = UIColor(named: O_NAVY2)!
        pagingVC.borderColor = UIColor(named: O_NAVY2)!
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            NSLayoutConstraint.activate([
                pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 25)
            ])
            break
        default:
            break
        }
    }
}
