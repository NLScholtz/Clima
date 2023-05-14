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

class FavouriteWeatherViewController: UIViewController{

    lazy var viewModel = FavouriteWeatherViewModel()
    var delegate: FavouriteWeatherViewControllerDelegate?

    @IBOutlet weak var favouriteWeatherTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.retrieveFavouriteCities()
    }
}

extension FavouriteWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFavouriteCities
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteWeatherTableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteWeatherTableViewCell
        cell.favouriteCityName.text = viewModel.favouriteCityName(at: indexPath.row)
        //cell.favouriteCityDate.text = favouriteWeather[indexPath.row].date?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = viewModel.favouriteCityName(at: indexPath.row).description
        //guard let favouriteCityName = selectedCity else { return }
        delegate?.favouriteCitySelected(cityName: selectedCity)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.favouriteCity = WeatherStorageManager.shareInstance.deleteFavouriteCity(index: indexPath.row)
            self.favouriteWeatherTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension FavouriteWeatherViewController: MainViewModelDelegate {
    func weatherUpdated() { }
    func city(isFavourite: Bool) { }
}
