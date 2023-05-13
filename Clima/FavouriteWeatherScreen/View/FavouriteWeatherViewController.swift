//
//  FavouriteWeatherViewController.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/08.
//

import UIKit

protocol FavouriteWeatherViewControllerDelegate {
    func favouriteCitySelected(cityName: String)
}

class FavouriteWeatherViewController: UIViewController {
    
    var favouriteWeather = [FavouriteCity]()
    var delegate: FavouriteWeatherViewControllerDelegate?
    var weatherManager = WeatherStorageManager()

    @IBOutlet weak var favouriteWeatherTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteWeather = weatherManager.getWeatherData()
    }
}


extension FavouriteWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteWeatherTableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteWeatherTableViewCell
        cell.favouriteCityName.text = favouriteWeather[indexPath.row].name?.description
        //cell.favouriteCityDate.text = favouriteWeather[indexPath.row].date?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = favouriteWeather[indexPath.row].name?.description
        guard let favouriteCityName = selectedCity else { return }
        delegate?.favouriteCitySelected(cityName: favouriteCityName)
        dismiss(animated: true)
    }
    
}
