//
//  ViewController.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/08.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var toggleAppearance: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleAppearance.addTarget(self, action: #selector(toggleAppearanceStyle), for: .touchUpInside)
        self.view.addSubview(toggleAppearance)
    }
    
    @IBAction func saveWeather(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(systemName: "bookmark") {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
}

extension MainViewController {
    @objc func toggleAppearanceStyle() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let appearanceStyle = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        
        if appearanceStyle != .dark {
            window?.overrideUserInterfaceStyle = .dark
            toggleAppearance.setImage(UIImage(systemName: "camera.macro.circle.fill"), for: .normal)
        } else {
            window?.overrideUserInterfaceStyle = .light
            toggleAppearance.setImage(UIImage(systemName: "fish.circle.fill"), for: .normal)
        }
    }
}

