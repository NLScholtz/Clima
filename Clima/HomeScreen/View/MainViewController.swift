//
//  ViewController.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/08.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    private lazy var viewModel = MainViewModel(delegate: self, coreManager: WeatherStorageManager(), locationManager: LocationManager())
    
    @IBOutlet weak var toggleAppearance: UIButton!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var mainCurrentTemperature: UILabel!
    @IBOutlet weak var currentTemperate: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherCondition: UILabel!
    @IBOutlet weak var weatherBackground: UIImageView!
    @IBOutlet weak var weatherParentView: UIView!
    @IBOutlet weak var lastUpdatedDate: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        toggleAppearance.addTarget(self, action: #selector(toggleAppearanceStyle), for: .touchUpInside)
        self.view.addSubview(toggleAppearance)
        
        if CheckNetworkConnection.isConnectedToNetwork() {
            viewModel.setupLocationManager()
        } else {
            showOfflineAlert()
            viewModel.retrieveOfflineWeather()
        }
    }
    
    @IBAction func showCurrentLocation(_ sender: UIButton) {
        viewModel.setupLocationManager()
    }
    
    @IBAction func storeWeatherLocationToFavourites(_ sender: UIButton) {
        viewModel.saveWeatherOffline(cityName: cityName.text ?? "")
        sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
    }
    
    @IBAction func searchWeatherByCity(_ sender: UIButton) {
        showCityDialog(title: "Search City", subtitle: "Provide a city name do display the weather", actionTitle: "OK", cancelTitle: "Cancel", inputPlaceholder: "Johannesburg", inputKeyboardType: .default, actionHandler: { (city:String?) in
            //print("The searched city is \(city ?? "")")
            self.viewModel.cityDetermined(city: city ?? "")
        })
    }
    
    @IBAction func displayFavourites(_ sender: UIButton) {
        performSegue(withIdentifier: "showFavouriteWeather", sender: self)
    }
    
    @IBAction func offlineModeButton(_ sender: UIButton) {
        showOfflineAlert()
        viewModel.retrieveOfflineWeather()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let favouriteViewController = segue.destination as! FavouriteWeatherViewController
        favouriteViewController.delegate = self
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfForecast
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
        let forecast = viewModel.forecastDays[indexPath.row]
        cell.forecastDay.text = forecast.description
        cell.forecastTemperature?.text = viewModel.currentTemperature(at: indexPath.row)
        cell.forecastIcon.image = viewModel.weatherConditionImage(at: indexPath.row)
        return cell
    }
    
    @objc func toggleAppearanceStyle() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let appearanceStyle = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        
        if appearanceStyle != .dark {
            toggleAppearance.setImage(UIImage(systemName: "camera.macro.circle.fill"), for: .normal)
            window?.overrideUserInterfaceStyle = .dark
        } else {
            toggleAppearance.setImage(UIImage(systemName: "fish.circle.fill"), for: .normal)
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    func showOfflineAlert() {
        let alert = UIAlertController(title: "Offline", message: "You are now offline and will only view last location", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension MainViewController: MainViewModelDelegate, FavouriteWeatherViewModelDelegate {
    func city(isFavourite: Bool) {
        if isFavourite {
            favouriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    func favouriteWeather(object: [String : String], index: Int) {
        cityName.text = object["name"]
    }
    
    func weatherUpdated() {
        self.loadingView.isHidden = false
        self.activityIndicator.startAnimating()
        cityName.text = viewModel.cityName
        mainCurrentTemperature.text = viewModel.currentTemperature(at: 0)
        currentTemperate.text = viewModel.currentTemperature(at: 0)
        minTemperature.text = viewModel.minTemperature(at: 0)
        maxTemperature.text = viewModel.maxTemperature(at: 0)
        weatherCondition.text = viewModel.weatherCondtion(at: 0)
        weatherBackground.image = viewModel.weatherBackgroundState (at: 0)
        weatherParentView.backgroundColor = viewModel.weatherColorState(at: 0)
        
        DispatchQueue.main.async {
            self.forecastTableView.reloadData()
            self.loadingView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}

extension MainViewController: FavouriteWeatherViewControllerDelegate {
    func favouriteCitySelected(cityName: String) {
        self.viewModel.cityDetermined(city: cityName )
    }
}
