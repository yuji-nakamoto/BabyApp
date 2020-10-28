//
//  ParchmentMelodyViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import Parchment

class ParchmentMelodyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sleepVC = storyboard.instantiateViewController(withIdentifier: "SleepVC")
        let funVC = storyboard.instantiateViewController(withIdentifier: "FunVC")
        let etcetraVC = storyboard.instantiateViewController(withIdentifier: "EtcetraVC")
        
        sleepVC.title = "泣き止む"
        funVC.title = "楽しい"
        etcetraVC.title = "その他"
        
        let pagingVC = PagingViewController(viewControllers: [sleepVC, funVC, etcetraVC])
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        ])
        
        pagingVC.font = UIFont(name: "HiraMaruProN-W4", size: 11)!
        pagingVC.selectedFont = UIFont(name: "HiraMaruProN-W4", size: 13)!
        pagingVC.selectedTextColor = .black
        pagingVC.indicatorColor = UIColor.systemIndigo
        pagingVC.menuItemSize = .fixed(width: 120, height: 40)
        pagingVC.menuHorizontalAlignment = .center
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!]
    }
}
