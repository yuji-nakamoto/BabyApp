//
//  NatureTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/02.
//

import UIKit
import GoogleMobileAds

class NatureTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let soundFilePath1 = Bundle.main.path(forResource: "springwater", ofType: "mp3")
    private let soundFilePath2 = Bundle.main.path(forResource: "brook", ofType: "mp3")
    private let soundFilePath3 = Bundle.main.path(forResource: "cave", ofType: "mp3")
    private let soundFilePath4 = Bundle.main.path(forResource: "wave", ofType: "mp3")
    private let soundFilePath5 = Bundle.main.path(forResource: "glassland", ofType: "mp3")
    private let soundFilePath6 = Bundle.main.path(forResource: "wind", ofType: "mp3")
    private let soundFilePath7 = Bundle.main.path(forResource: "rain", ofType: "mp3")
    private let soundFilePath8 = Bundle.main.path(forResource: "higurashi", ofType: "mp3")
    private let soundFilePath9 = Bundle.main.path(forResource: "cricket", ofType: "mp3")
    private let soundFilePath10 = Bundle.main.path(forResource: "bird-chorus", ofType: "mp3")
    private let soundFilePath11 = Bundle.main.path(forResource: "flog", ofType: "mp3")
    lazy var sounds = [soundFilePath1, soundFilePath2, soundFilePath3, soundFilePath4, soundFilePath5, soundFilePath6, soundFilePath7, soundFilePath8, soundFilePath9, soundFilePath10, soundFilePath11]
    private var soundTexts = ["小川", "湧水", "鍾乳洞", "波", "草原", "台風", "雨", "ひぐらし", "コオロギ", "野鳥", "カエル"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
//        testBanner()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
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

extension NatureTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SoundTableViewCell
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE1) != nil {
            if indexPath.row == 0 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 0 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE2) != nil {
            if indexPath.row == 1 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 1 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE3) != nil {
            if indexPath.row == 2 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 2 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE4) != nil {
            if indexPath.row == 3 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 3 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE5) != nil {
            if indexPath.row == 4 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 4 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE6) != nil {
            if indexPath.row == 5 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 5 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE7) != nil {
            if indexPath.row == 6 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 6 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE8) != nil {
            if indexPath.row == 7 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 7 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE9) != nil {
            if indexPath.row == 8 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 8 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE10) != nil {
            if indexPath.row == 9 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 9 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE11) != nil {
            if indexPath.row == 10 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 10 {
                cell.favoButton.alpha = 1
            }
        }
        
        cell.natureVC = self
        cell.setupSound()
        cell.sounds = sounds[indexPath.row]
        cell.soundText = soundTexts[indexPath.row]
        cell.configureCell(soundText: soundTexts[indexPath.row])
        return cell
    }
}
