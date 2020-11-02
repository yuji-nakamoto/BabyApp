//
//  FavoriteCollectionViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/01.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class FavoriteCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let soundFilePath1 = Bundle.main.path(forResource: "vinyl", ofType: "mp3")
    private let soundFilePath2 = Bundle.main.path(forResource: "hairdryer", ofType: "mp3")
    private let soundFilePath3 = Bundle.main.path(forResource: "washing_machine2", ofType: "mp3")
    private let soundFilePath4 = Bundle.main.path(forResource: "boiling1", ofType: "mp3")
    private let soundFilePath5 = Bundle.main.path(forResource: "shower", ofType: "mp3")
    private let soundFilePath6 = Bundle.main.path(forResource: "pouring_water2", ofType: "mp3")
    private let soundFilePath7 = Bundle.main.path(forResource: "cleaner_nearly", ofType: "mp3")
    private let soundFilePath8 = Bundle.main.path(forResource: "cleaner_far", ofType: "mp3")
    private let soundFilePath9 = Bundle.main.path(forResource: "white_noise1", ofType: "mp3")
    private let soundFilePath10 = Bundle.main.path(forResource: "300hz_noise", ofType: "mp3")
    private let soundFunPath1 = Bundle.main.path(forResource: "magic5", ofType: "mp3")
    private let soundFunPath2 = Bundle.main.path(forResource: "jump06", ofType: "mp3")
    private let soundFunPath3 = Bundle.main.path(forResource: "poka", ofType: "mp3")
    private let soundFunPath4 = Bundle.main.path(forResource: "poyo", ofType: "mp3")
    private let soundFunPath5 = Bundle.main.path(forResource: "limp", ofType: "mp3")
    private let soundFunPath6 = Bundle.main.path(forResource: "by_chance", ofType: "mp3")
    private let soundFunPath7 = Bundle.main.path(forResource: "warp1", ofType: "mp3")
    private let soundFunPath8 = Bundle.main.path(forResource: "bright_bell1", ofType: "mp3")
    private let soundFunPath9 = Bundle.main.path(forResource: "funny", ofType: "mp3")
    private let soundAnimalPath1 = Bundle.main.path(forResource: "dog1b", ofType: "mp3")
    private let soundAnimalPath2 = Bundle.main.path(forResource: "cat1a", ofType: "mp3")
    private let soundAnimalPath3 = Bundle.main.path(forResource: "goat-cry1", ofType: "mp3")
    private let soundAnimalPath4 = Bundle.main.path(forResource: "elephant1", ofType: "mp3")
    private let soundAnimalPath5 = Bundle.main.path(forResource: "cow", ofType: "mp3")
    private let soundAnimalPath6 = Bundle.main.path(forResource: "monkey", ofType: "mp3")
    private let soundAnimalPath7 = Bundle.main.path(forResource: "chick", ofType: "mp3")
    private let soundAnimalPath8 = Bundle.main.path(forResource: "chicken-cry1", ofType: "mp3")
    private let soundAnimalPath9 = Bundle.main.path(forResource: "horornis-diphone-twitter1", ofType: "mp3")
    private let soundNaturePath1 = Bundle.main.path(forResource: "springwater", ofType: "mp3")
    private let soundNaturePath2 = Bundle.main.path(forResource: "brook", ofType: "mp3")
    private let soundNaturePath3 = Bundle.main.path(forResource: "cave", ofType: "mp3")
    private let soundNaturePath4 = Bundle.main.path(forResource: "wave", ofType: "mp3")
    private let soundNaturePath5 = Bundle.main.path(forResource: "glassland", ofType: "mp3")
    private let soundNaturePath6 = Bundle.main.path(forResource: "wind", ofType: "mp3")
    private let soundNaturePath7 = Bundle.main.path(forResource: "rain", ofType: "mp3")
    private let soundNaturePath8 = Bundle.main.path(forResource: "higurashi", ofType: "mp3")
    private let soundNaturePath9 = Bundle.main.path(forResource: "cricket", ofType: "mp3")
    private let soundNaturePath10 = Bundle.main.path(forResource: "bird-chorus", ofType: "mp3")
    private let soundNaturePath11 = Bundle.main.path(forResource: "flog", ofType: "mp3")
    private var sounds = [String]()
    private var soundTexts = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBanner()
        testBanner()
        setup()
        setSounds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: ADD_FAVO) != nil {
            setSounds()
            UserDefaults.standard.removeObject(forKey: ADD_FAVO)
        }
    }
    
    // MARK: - Helpers
    
    private func setup() {
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        navigationItem.title = "お気に入り"
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
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
    
    private func setSounds() {
        
        sounds.removeAll()
        soundTexts.removeAll()
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP1) != nil {
            sounds.append(soundFilePath1!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP1) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP2) != nil {
            sounds.append(soundFilePath2!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP2) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP3) != nil {
            sounds.append(soundFilePath3!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP3) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP4) != nil {
            sounds.append(soundFilePath4!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP4) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP5) != nil {
            sounds.append(soundFilePath5!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP5) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP6) != nil {
            sounds.append(soundFilePath6!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP6) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP7) != nil {
            sounds.append(soundFilePath7!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP7) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP8) != nil {
            sounds.append(soundFilePath8!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP8) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP9) != nil {
            sounds.append(soundFilePath9!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP9) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP10) != nil {
            sounds.append(soundFilePath10!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_SLEEP10) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_FUN1) != nil {
            sounds.append(soundFunPath1!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_FUN1) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_FUN2) != nil {
            sounds.append(soundFunPath2!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_FUN2) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_FUN3) != nil {
            sounds.append(soundFunPath3!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_FUN3) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_FUN4) != nil {
            sounds.append(soundFunPath4!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_FUN4) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_FUN5) != nil {
            sounds.append(soundFunPath5!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_FUN5) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_FUN6) != nil {
            sounds.append(soundFunPath6!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_FUN6) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_FUN7) != nil {
            sounds.append(soundFunPath7!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_FUN7) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_FUN8) != nil {
            sounds.append(soundFunPath8!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_FUN8) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_FUN9) != nil {
            sounds.append(soundFunPath9!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_FUN9) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL1) != nil {
            sounds.append(soundAnimalPath1!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_ANIMAL1) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL2) != nil {
            sounds.append(soundAnimalPath2!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_ANIMAL2) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL3) != nil {
            sounds.append(soundAnimalPath3!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_ANIMAL3) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL4) != nil {
            sounds.append(soundAnimalPath4!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_ANIMAL4) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL5) != nil {
            sounds.append(soundAnimalPath5!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_ANIMAL5) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL6) != nil {
            sounds.append(soundAnimalPath6!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_ANIMAL6) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL7) != nil {
            sounds.append(soundAnimalPath7!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_ANIMAL7) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL8) != nil {
            sounds.append(soundAnimalPath8!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_ANIMAL8) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_ANIMAL9) != nil {
            sounds.append(soundAnimalPath9!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_ANIMAL9) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE1) != nil {
            sounds.append(soundNaturePath1!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE1) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE2) != nil {
            sounds.append(soundNaturePath2!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE2) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE3) != nil {
            sounds.append(soundNaturePath3!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE3) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE4) != nil {
            sounds.append(soundNaturePath4!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE4) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE5) != nil {
            sounds.append(soundNaturePath5!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE5) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE6) != nil {
            sounds.append(soundNaturePath6!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE6) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE7) != nil {
            sounds.append(soundNaturePath7!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE7) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE8) != nil {
            sounds.append(soundNaturePath8!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE8) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE9) != nil {
            sounds.append(soundNaturePath9!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE9) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE10) != nil {
            sounds.append(soundNaturePath10!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE10) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_NATURE11) != nil {
            sounds.append(soundNaturePath11!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_NATURE11) as! String)
        }
        collectionView.reloadData()
    }
}

extension FavoriteCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soundTexts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FavoriteCollectionViewCell
        
        cell.favoVC = self
        cell.sounds = sounds[indexPath.row]
        cell.soundText = soundTexts[indexPath.row]
        cell.configureCell(soundText: soundTexts[indexPath.row])
        cell.setupSound()
        cell.setupReleseSound()
        return cell
    }
}

extension FavoriteCollectionViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "お気に入りはありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray2 as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "星マークからお気に入り登録ができます", attributes: attributes)
    }
}
