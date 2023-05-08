//
//  LaunchViewController.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/08.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBar.progress = 0.0
        
        UIView.animate(withDuration: 4.0) {
            self.progressBar.setProgress(1.0, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.performSegue(withIdentifier: "showMainScreen", sender: self)
        }
    }
}
