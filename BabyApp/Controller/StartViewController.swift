//
//  StartViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/02.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    private func start() {
        indicator.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            if UserDefaults.standard.object(forKey: END_TUTORIAL) != nil {
                indicator.stopAnimating()
                toTabVC()
            } else {
                indicator.stopAnimating()
                toTutorialVC()
            }
        }
    }
    
    private func toTabVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
        self.present(tabVC, animated: true, completion: nil)
    }
    
    private func toTutorialVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorialVC = storyboard.instantiateViewController(withIdentifier: "TutorialVC")
        self.present(tutorialVC, animated: true, completion: nil)
    }
}
