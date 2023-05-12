//
//  FavouriteWeatherViewController.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/08.
//

import UIKit

class FavouriteWeatherViewController: UIViewController {

    @IBOutlet weak var favouriteWeatherTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FavouriteWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteWeatherTableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteWeatherTableViewCell
        
        return cell
    }
    
    
}
