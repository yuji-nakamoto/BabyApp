//
//  AnimalTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit
import GoogleMobileAds

class AnimalTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let soundFilePath1 = Bundle.main.path(forResource: "small_dog2", ofType: "mp3")
    private let soundFilePath2 = Bundle.main.path(forResource: "cat1a", ofType: "mp3")
    private let soundFilePath3 = Bundle.main.path(forResource: "goat-cry1", ofType: "mp3")
    private let soundFilePath4 = Bundle.main.path(forResource: "elephant1", ofType: "mp3")
    private let soundFilePath5 = Bundle.main.path(forResource: "cow1", ofType: "mp3")
    private let soundFilePath6 = Bundle.main.path(forResource: "crow1", ofType: "mp3")
    private let soundFilePath7 = Bundle.main.path(forResource: "chick", ofType: "mp3")
    private let soundFilePath8 = Bundle.main.path(forResource: "chicken-cry1", ofType: "mp3")
    private let soundFilePath9 = Bundle.main.path(forResource: "horornis-diphone-twitter1", ofType: "mp3")
    lazy var sounds = [soundFilePath1, soundFilePath2, soundFilePath3, soundFilePath4, soundFilePath5, soundFilePath6, soundFilePath7, soundFilePath8, soundFilePath9]
    private var soundTexts = ["いぬ", "ねこ", "やぎ", "ぞう", "うし", "からす", "ひよこ", "にわとり", "うぐいす"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBanner()
        testBanner()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        UserDefaults.standard.removeObject(forKey: ON_FUN_VC)
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func testBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension AnimalTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SoundTableViewCell
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL1) != nil {
            if indexPath.row == 0 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 0 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL2) != nil {
            if indexPath.row == 1 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 1 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL3) != nil {
            if indexPath.row == 2 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 2 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL4) != nil {
            if indexPath.row == 3 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 3 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL5) != nil {
            if indexPath.row == 4 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 4 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL6) != nil {
            if indexPath.row == 5 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 5 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL7) != nil {
            if indexPath.row == 6 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 6 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL8) != nil {
            if indexPath.row == 7 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 7 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL9) != nil {
            if indexPath.row == 8 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 8 {
                cell.favoButton.alpha = 1
            }
        }
        
        cell.animalVC = self
        cell.setupSound()
        cell.sounds = sounds[indexPath.row]
        cell.soundText = soundTexts[indexPath.row]
        cell.configureCell(soundText: soundTexts[indexPath.row])
        return cell
    }
}
