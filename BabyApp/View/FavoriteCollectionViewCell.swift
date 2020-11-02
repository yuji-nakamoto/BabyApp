//
//  FavoiteCollectionViewCell.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/01.
//

import UIKit
import AVFoundation
import JGProgressHUD

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var soundNameLbl: UILabel!
    @IBOutlet weak var playBackImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var releaseButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    var soundText: String?
    var sounds: String?
    var favoVC: FavoriteCollectionViewController?
    private var player1 = AVAudioPlayer()
    private var player2 = AVAudioPlayer()
    private let soundFilePath = Bundle.main.path(forResource: "wadding_up1", ofType: "mp3")
    private var hud = JGProgressHUD(style: .dark)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playBackImageView.layer.cornerRadius = 70 / 2
        playBackImageView.layer.borderWidth = 2
        playBackImageView.layer.borderColor = UIColor.white.cgColor
        playBackImageView.backgroundColor = .clear
        playBackImageView.alpha = 1
        slider.value = 15
    }
    
    // MARK: - Helpers
    
    func configureCell(soundText: String) {
        soundNameLbl.text = soundText
    }
    
    func setupSound() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            do {
                try player1 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: sounds!))
                player1.prepareToPlay()
            } catch  {
                print("Error sound", error.localizedDescription)
            }
        }
    }
    
    func setupReleseSound() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            do {
                try player2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFilePath!))
                player2.prepareToPlay()
            } catch  {
                print("Error sound", error.localizedDescription)
            }
        }
    }

    private func setupHudSuccess2() {
        hud.textLabel.text = "解除しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (favoVC?.view)!)
        hud.dismiss(afterDelay: 1)
    }
    
    // MARK: - Actions
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        if playImageView.image == UIImage(systemName: "play.fill") {
            player1.play()
            player1.numberOfLoops = -1
            
            UIView.animate(withDuration: 0.3) { [self] in
                releaseButton.alpha = 0
                playImageView.image = UIImage(systemName: "pause.fill")
                playBackImageView.backgroundColor = .systemGray
                playBackImageView.layer.borderColor = UIColor.systemGray.cgColor
                playBackImageView.alpha = 0.5
            }
        } else {
            
            player1.stop()
            UIView.animate(withDuration: 0.3) { [self] in
                releaseButton.alpha = 1
                playImageView.image = UIImage(systemName: "play.fill")
                playBackImageView.layer.borderColor = UIColor.white.cgColor
                playBackImageView.backgroundColor = .clear
                playBackImageView.alpha = 1
            }
        }
    }
    
    @IBAction func onSlider(_ sender: UISlider) {
        let sliderValue = Float(sender.value / 10)
        player1.volume = sliderValue
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: soundText, message: "お気に入りを解除しますか？", preferredStyle: .alert)
        let release = UIAlertAction(title: "解除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            player2.play()
            if soundNameLbl.text == "ビニール袋" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP1)
            }
            
            if soundNameLbl.text == "ドライヤー" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP2)
            }
            
            if soundNameLbl.text == "洗濯機" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP3)
            }
            
            if soundNameLbl.text == "煮物" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP4)
            }
            
            if soundNameLbl.text == "シャワー" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP5)
            }
            
            if soundNameLbl.text == "水を注ぐ" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP6)
            }
            
            if soundNameLbl.text == "掃除機1" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP7)
            }
            
            if soundNameLbl.text == "掃除機2" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP8)
            }
            
            if soundNameLbl.text == "砂嵐" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP9)
            }
            
            if soundNameLbl.text == "ノイズ" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP10)
            }
            
            if soundNameLbl.text == "魔法" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN1)
            }
            
            if soundNameLbl.text == "ジャンプ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN2)
            }
            
            if soundNameLbl.text == "ポカッ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN3)
            }
            
            if soundNameLbl.text == "プンッ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN4)
            }
            
            if soundNameLbl.text == "ブゥーン" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN5)
            }
            
            if soundNameLbl.text == "ポォーン" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN6)
            }
            
            if soundNameLbl.text == "ワープ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN7)
            }
            
            if soundNameLbl.text == "キラキラ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN8)
            }
            
            if soundNameLbl.text == "カーニバル" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN9)
            }

            if soundNameLbl.text == "いぬ" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL1)
            }
            
            if soundNameLbl.text == "ねこ" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL2)
            }
            
            if soundNameLbl.text == "やぎ" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL3)
            }
            
            if soundNameLbl.text == "ぞう" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL4)
            }
            
            if soundNameLbl.text == "うし" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL5)
            }
            
            if soundNameLbl.text == "さる" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL6)
            }
            
            if soundNameLbl.text == "ひよこ" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL7)
            }
            
            if soundNameLbl.text == "にわとり" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL8)
            }
            
            if soundNameLbl.text == "うぐいす" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL9)
            }
            
            if soundNameLbl.text == "小川" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE1)
            }
            
            if soundNameLbl.text == "湧水" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE2)
            }
            
            if soundNameLbl.text == "鍾乳洞" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE3)
            }
            
            if soundNameLbl.text == "波" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE4)
            }
            
            if soundNameLbl.text == "草原" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE5)
            }
            
            if soundNameLbl.text == "台風" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE6)
            }
            
            if soundNameLbl.text == "雨" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE7)
            }
            
            if soundNameLbl.text == "ひぐらし" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE8)
            }
            
            if soundNameLbl.text == "コオロギ" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE9)
            }
            
            if soundNameLbl.text == "野鳥" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE10)
            }
            
            if soundNameLbl.text == "カエル" {
                UserDefaults.standard.removeObject(forKey: FAVO_NATURE11)
            }
            
            setupHudSuccess2()
            favoVC?.viewDidLoad()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                player2.stop()
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(release)
        alert.addAction(cancel)
        favoVC?.present(alert,animated: true,completion: nil)
    }
}
