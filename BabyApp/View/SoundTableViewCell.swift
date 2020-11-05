//
//  SoundTableTableViewCell.swift.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import AVFoundation
import JGProgressHUD

class SoundTableViewCell: UITableViewCell {
    
    @IBOutlet weak var soundNameLbl: UILabel!
    @IBOutlet weak var favoButton: UIButton!
    @IBOutlet weak var pauseImageView: UIImageView!
    @IBOutlet weak var pauseImageButton: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var backImageView: UIImageView!
    
    var soundText: String?
    var sounds: String?
    var animationFile: String?
    var sleepVC: SleepTableViewController?
    var funVC: FunTableViewController?
    var animalVC: AnimalTableViewController?
    var natureVC: NatureTableViewController?
    private var player1 = AVAudioPlayer()
    private var player2 = AVAudioPlayer()
    private var hud = JGProgressHUD(style: .dark)
    private let soundFilePath = Bundle.main.path(forResource: "decision", ofType: "mp3")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSleepLbl))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapPauseImageView))
        pauseImageButton.addGestureRecognizer(tap2)
        soundNameLbl.addGestureRecognizer(tap)
        
        backImageView.layer.cornerRadius = 50 / 2
        soundNameLbl.layer.cornerRadius = 50 / 2
        soundNameLbl.layer.borderWidth = 1.5
        soundNameLbl.layer.borderColor = UIColor.white.cgColor
        soundNameLbl.backgroundColor = .clear
        soundNameLbl.alpha = 1
        slider.value = 15
        pauseImageView.alpha = 0
        pauseImageButton.alpha = 0
    }
    
    // MARK: - Helpers
    
    func configureCell(soundText: String) {
        soundNameLbl.text = soundText
    }
    
    func setupSound1() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            do {
                try player1 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: sounds!))
                player1.prepareToPlay()
            } catch  {
                print("Error sound", error.localizedDescription)
            }
        }
    }
    
    func setupSound2() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            do {
                try player2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFilePath!))
                player2.prepareToPlay()
            } catch  {
                print("Error sound", error.localizedDescription)
            }
        }
    }
    
    private func setupHudSuccess1() {
        hud.textLabel.text = "登録しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (sleepVC?.view)!)
        hud.dismiss(afterDelay: 1)
    }
    
    private func setupHudSuccess2() {
        hud.textLabel.text = "登録しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (natureVC?.view)!)
        hud.dismiss(afterDelay: 1)
    }
    
    private func setupHudSuccess3() {
        hud.textLabel.text = "登録しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (funVC?.view)!)
        hud.dismiss(afterDelay: 1)
    }
    
    private func setupHudSuccess4() {
        hud.textLabel.text = "登録しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (animalVC?.view)!)
        hud.dismiss(afterDelay: 1)
    }
    
    // MARK: - Actions
    
    @IBAction func onSlider(_ sender: UISlider) {
        let sliderValue = Float(sender.value / 10)
        player1.volume = sliderValue
    }
    
    @objc func tapSleepLbl() {
        
        player1.play()
        player1.numberOfLoops = -1
                
        UIView.animate(withDuration: 0.3) { [self] in
            pauseImageView.alpha = 1
            pauseImageButton.alpha = 1
            favoButton.isHidden = true
            soundNameLbl.text = ""
            soundNameLbl.backgroundColor = .darkGray
            soundNameLbl.layer.borderColor = UIColor.darkGray.cgColor
            soundNameLbl.alpha = 0.8
        }
    }
    
    @objc func tapPauseImageView() {
        
        player1.stop()
        pauseImageView.alpha = 0
        pauseImageButton.alpha = 0
        
        UIView.animate(withDuration: 0.3) { [self] in
            favoButton.isHidden = false
            soundNameLbl.text = soundText
            soundNameLbl.alpha = 1
            soundNameLbl.backgroundColor = .clear
            soundNameLbl.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBAction func favoButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: soundText, message: "お気に入り登録しますか？", preferredStyle: .alert)
        let alert2 = UIAlertController(title: soundText, message: "お気に入り登録済みです", preferredStyle: .alert)
        let veritification = UIAlertAction(title: "確認", style: .cancel)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let registration = UIAlertAction(title: "登録する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            player2.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rollingAnimation.fromValue = 0
                rollingAnimation.toValue = CGFloat.pi * -0.1
                rollingAnimation.duration = 0.1
                rollingAnimation.repeatDuration = CFTimeInterval.zero
                favoButton.layer.add(rollingAnimation, forKey: "rollingImage")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
                    rollingAnimation.fromValue = 0
                    rollingAnimation.toValue = CGFloat.pi * 0.1
                    rollingAnimation.duration = 0.1
                    rollingAnimation.repeatDuration = CFTimeInterval.zero
                    favoButton.layer.add(rollingAnimation, forKey: "rollingImage")
                }
            }
            
            if soundNameLbl.text == "ビニール袋" {
                setupHudSuccess1()
                UserDefaults.standard.set("ビニール袋", forKey: FAVO_SLEEP1)
            }
            
            if soundNameLbl.text == "ドライヤー" {
                setupHudSuccess1()
                UserDefaults.standard.set("ドライヤー", forKey: FAVO_SLEEP2)
            }
            
            if soundNameLbl.text == "洗濯機" {
                setupHudSuccess1()
                UserDefaults.standard.set("洗濯機", forKey: FAVO_SLEEP3)
            }
            
            if soundNameLbl.text == "煮物" {
                setupHudSuccess1()
                UserDefaults.standard.set("煮物", forKey: FAVO_SLEEP4)
            }
            
            if soundNameLbl.text == "シャワー" {
                setupHudSuccess1()
                UserDefaults.standard.set("シャワー", forKey: FAVO_SLEEP5)
            }
            
            if soundNameLbl.text == "水を注ぐ" {
                setupHudSuccess1()
                UserDefaults.standard.set("水を注ぐ", forKey: FAVO_SLEEP6)
            }
            
            if soundNameLbl.text == "掃除機1" {
                setupHudSuccess1()
                UserDefaults.standard.set("掃除機1", forKey: FAVO_SLEEP7)
            }
            
            if soundNameLbl.text == "掃除機2" {
                setupHudSuccess1()
                UserDefaults.standard.set("掃除機2", forKey: FAVO_SLEEP8)
            }
            
            if soundNameLbl.text == "砂嵐" {
                setupHudSuccess1()
                UserDefaults.standard.set("砂嵐", forKey: FAVO_SLEEP9)
            }
            
            if soundNameLbl.text == "ノイズ" {
                setupHudSuccess1()
                UserDefaults.standard.set("ノイズ", forKey: FAVO_SLEEP10)
            }
            
            if soundNameLbl.text == "魔法" {
                setupHudSuccess3()
                UserDefaults.standard.set("魔法", forKey: FAVO_FUN1)
            }
            
            if soundNameLbl.text == "ジャンプ" {
                setupHudSuccess3()
                UserDefaults.standard.set("ジャンプ", forKey: FAVO_FUN2)
            }
            
            if soundNameLbl.text == "ポカッ" {
                setupHudSuccess3()
                UserDefaults.standard.set("ポカッ", forKey: FAVO_FUN3)
            }
            
            if soundNameLbl.text == "プンッ" {
                setupHudSuccess3()
                UserDefaults.standard.set("プンッ", forKey: FAVO_FUN4)
            }
            
            if soundNameLbl.text == "ブゥーン" {
                setupHudSuccess3()
                UserDefaults.standard.set("ブゥーン", forKey: FAVO_FUN5)
            }
            
            if soundNameLbl.text == "ポォーン" {
                setupHudSuccess3()
                UserDefaults.standard.set("ポォーン", forKey: FAVO_FUN6)
            }
            
            if soundNameLbl.text == "ワープ" {
                setupHudSuccess3()
                UserDefaults.standard.set("ワープ", forKey: FAVO_FUN7)
            }
            
            if soundNameLbl.text == "キラキラ" {
                setupHudSuccess3()
                UserDefaults.standard.set("キラキラ", forKey: FAVO_FUN7)
            }
            
            if soundNameLbl.text == "カーニバル" {
                setupHudSuccess3()
                UserDefaults.standard.set("カーニバル", forKey: FAVO_FUN8)
            }
            
            if soundNameLbl.text == "いぬ" {
                setupHudSuccess4()
                UserDefaults.standard.set("いぬ", forKey: FAVO_ANIMAL1)
            }
            
            if soundNameLbl.text == "ねこ" {
                setupHudSuccess4()
                UserDefaults.standard.set("ねこ", forKey: FAVO_ANIMAL2)
            }
            
            if soundNameLbl.text == "やぎ" {
                setupHudSuccess4()
                UserDefaults.standard.set("やぎ", forKey: FAVO_ANIMAL3)
            }
            
            if soundNameLbl.text == "ぞう" {
                setupHudSuccess4()
                UserDefaults.standard.set("ぞう", forKey: FAVO_ANIMAL4)
            }
            
            if soundNameLbl.text == "うし" {
                setupHudSuccess4()
                UserDefaults.standard.set("うし", forKey: FAVO_ANIMAL5)
            }
            
            if soundNameLbl.text == "さる" {
                setupHudSuccess4()
                UserDefaults.standard.set("さる", forKey: FAVO_ANIMAL6)
            }
            
            if soundNameLbl.text == "ひよこ" {
                setupHudSuccess4()
                UserDefaults.standard.set("ひよこ", forKey: FAVO_ANIMAL7)
            }
            
            if soundNameLbl.text == "にわとり" {
                setupHudSuccess4()
                UserDefaults.standard.set("にわとり", forKey: FAVO_ANIMAL8)
            }
            
            if soundNameLbl.text == "うぐいす" {
                setupHudSuccess4()
                UserDefaults.standard.set("うぐいす", forKey: FAVO_ANIMAL9)
            }
            
            if soundNameLbl.text == "小川" {
                setupHudSuccess2()
                UserDefaults.standard.set("小川", forKey: FAVO_NATURE1)
            }
            
            if soundNameLbl.text == "湧水" {
                setupHudSuccess2()
                UserDefaults.standard.set("湧水", forKey: FAVO_NATURE2)
            }
            
            if soundNameLbl.text == "鍾乳洞" {
                setupHudSuccess2()
                UserDefaults.standard.set("鍾乳洞", forKey: FAVO_NATURE3)
            }
            
            if soundNameLbl.text == "波" {
                setupHudSuccess2()
                UserDefaults.standard.set("波", forKey: FAVO_NATURE4)
            }
            
            if soundNameLbl.text == "草原" {
                setupHudSuccess2()
                UserDefaults.standard.set("草原", forKey: FAVO_NATURE5)
            }
            
            if soundNameLbl.text == "台風" {
                setupHudSuccess2()
                UserDefaults.standard.set("台風", forKey: FAVO_NATURE6)
            }
            
            if soundNameLbl.text == "雨" {
                setupHudSuccess2()
                UserDefaults.standard.set("雨", forKey: FAVO_NATURE7)
            }
            
            if soundNameLbl.text == "ひぐらし" {
                setupHudSuccess2()
                UserDefaults.standard.set("ひぐらし", forKey: FAVO_NATURE8)
            }
            
            if soundNameLbl.text == "コオロギ" {
                setupHudSuccess2()
                UserDefaults.standard.set("コオロギ", forKey: FAVO_NATURE9)
            }
            
            if soundNameLbl.text == "野鳥" {
                setupHudSuccess2()
                UserDefaults.standard.set("野鳥", forKey: FAVO_NATURE10)
            }
            
            if soundNameLbl.text == "カエル" {
                setupHudSuccess2()
                UserDefaults.standard.set("カエル", forKey: FAVO_NATURE11)
            }
            
            UserDefaults.standard.set(true, forKey: ADD_FAVO)
            sleepVC?.tableView.reloadData()
            funVC?.tableView.reloadData()
            animalVC?.tableView.reloadData()
            natureVC?.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                player2.stop()
            }
        }
        
        if favoButton.alpha == 0.5 {
            alert2.addAction(veritification)
            sleepVC?.present(alert2,animated: true,completion: nil)
            funVC?.present(alert2,animated: true,completion: nil)
            animalVC?.present(alert2,animated: true,completion: nil)
            natureVC?.present(alert2,animated: true,completion: nil)
        } else {
            alert.addAction(registration)
            alert.addAction(cancel)
            sleepVC?.present(alert,animated: true,completion: nil)
            funVC?.present(alert,animated: true,completion: nil)
            animalVC?.present(alert,animated: true,completion: nil)
            natureVC?.present(alert,animated: true,completion: nil)
        }
    }
}
