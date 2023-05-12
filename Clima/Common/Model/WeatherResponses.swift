//
//  Responses.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/08.
//

import Foundation

struct WeatherResponses: Codable {
    let list: [WeatherList]
    let city: WeatherCity
}

struct WeatherList: Codable {
    let main: WeatherMain
    let weather: [Weather]
}

struct WeatherMain: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
}

struct WeatherCity: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}


