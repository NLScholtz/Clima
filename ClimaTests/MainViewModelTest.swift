//
//  ClimaTests.swift
//  ClimaTests
//
//  Created by Nicole Scholtz on 2023/05/13.
//

@testable import Clima
import XCTest
import CoreLocation

final class MainViewModelTest: XCTestCase {
    
    ///TO-DO!!!
    
    var locationManager = CLLocationManager()
    var viewModelToTest: MainViewModel?

    override func setUpWithError() throws {
        viewModelToTest = MainViewModel(delegate: self, coreManager: WeatherStorageManager(), locationManager: LocationManager())
        viewModelToTest?.forecastDays = ["Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    }
    
    override func tearDownWithError() throws { }

    func testLocationSetup() throws {
        viewModelToTest?.setupLocationManager()
    }
    
    func testNumberOfForecasts() throws {
        XCTAssertTrue(viewModelToTest?.forecastDays.count == 5, "Number of forecasts are incorrect")
        //XCTAssertTrue(viewModelToTest?.numberOfForecast == 5, "Number of forecasts are incorrect")
    }
    
    func testCurrentTemperature() throws {
        XCTAssertTrue(viewModelToTest?.currentTemperature(at: 0) != nil, "Current Temperature is incorrect")
    }
    
    func testMinTemperature() throws {
        XCTAssertTrue(viewModelToTest?.minTemperature(at: 0) != nil, "Min Temperature is incorrect")
    }
    
    func testMaxTemperature() throws {
        XCTAssertTrue(viewModelToTest?.maxTemperature(at: 0) != nil, "Max Temperature is incorrect")
    }
    
    func testWeatherCondtion() throws {
        XCTAssertTrue(viewModelToTest?.weatherCondtion(at: 0) != nil, "Weather Condition is incorrect")
    }
    
    func testWeatherConditionImage() throws {
        XCTAssertTrue(viewModelToTest?.weatherConditionImage(at: 0) != nil, "Weather Condition is incorrect")
    }
    
    func testWeatherBackgroundState() throws {
        XCTAssertTrue(viewModelToTest?.weatherBackgroundState(at: 0) != nil, "Weather Condition is incorrect")
    }
    
    func testWeatherColoState() throws {
        XCTAssertTrue(viewModelToTest?.weatherColorState(at: 0) != nil, "Weather Condition is incorrect")
    }
    
    func testSaveWeatherOffline() throws {
        XCTAssertTrue(viewModelToTest?.saveWeatherOffline(cityName: "Centurion") != nil, "Weather could not be saved")
    }
    
    func testGetOfflineWeather() throws {
        XCTAssertTrue(viewModelToTest?.getOfflineWeather() != nil, "Could not get offline weather")
    }
    
    func testCityRevceived() throws {
        
    }
    
    func testLocationReceived() throws {
        struct MockLocationManager: LocationManagable {
            func setupLocationManager(locationDelegate: Clima.LocationManagerDelegate?) {
                locationDelegate?.locationDetermined(lat: 26.88, lon: 23.867)
            }
        }
        
        class MockDelegate: LocationManagerDelegate {
            func locationDetermined(lat: Double, lon: Double) {
                XCTAssertTrue(lat == 26.88)
                XCTAssertTrue(lon == 23.867)
            }
        }
        
        let viewModelToTest = MainViewModel(delegate: self, coreManager: WeatherStorageManager(), locationManager: MockLocationManager())
        viewModelToTest.locationManager?.setupLocationManager(locationDelegate: MockDelegate())
    }
    
    func testProcessWeatherResponse() throws {
        
        let weatherResponses = WeatherResponses(list: [WeatherList(main: WeatherMain(temp: 20, temp_min: 16, temp_max: 23), weather: [Weather(id: 500, main: "Rain")])], city: WeatherCity(id: 5391959, name: "Centurion", coord: Coordinates(lat: 26.88, lon: 23.867)))
        viewModelToTest?.processWeatherResponse(.success(weatherResponses))
        XCTAssertTrue(viewModelToTest?.cityName == weatherResponses.city.name, "Incorrect city name")
        //XCTAssertTrue(viewModelToTest?.currentTemperature(at: 0) != nil, "Incorrect temperature")
    }
}

extension MainViewModelTest: MainViewModelDelegate {
    func weatherUpdated() { }
    func city(isFavourite: Bool) { }
}
