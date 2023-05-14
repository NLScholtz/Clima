//
//  WeatherConstants.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/08.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func getWeather<T: Decodable>(with components: URLComponents, completion: ((Result<T, Error>) -> Void)?)
}

class WeatherManager {
    
    private let appId = "e153dc8c7be638e11ffb58ee935fe7dd"
    private let apiHost = "api.openweathermap.org"
    private let apiPath = "/data/2.5/forecast"
    
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
    private enum HTTP_Methods {
        static let get = "GET"
    }
    
    func getWeatherResponse(lat: String, lon: String, completion: ((Result<WeatherResponses>) -> Void)?) -> () {
        var urlComponents = getBaseComponent()
        let queryItemLan = URLQueryItem(name: "lat", value: lat)
        let queryItemLon = URLQueryItem(name: "lon", value:lon)
        
        urlComponents.queryItems?.append(queryItemLan)
        urlComponents.queryItems?.append(queryItemLon)
        getWeather(with: urlComponents, completion: completion)
    }
    
    func getWeatherResponseByCity(city: String, completion: ((Result<WeatherResponses>) -> Void)?) {
        var urlComponents = getBaseComponent()
        let queryItemCity = URLQueryItem(name: "q", value: city)
            
        urlComponents.queryItems?.append(queryItemCity)
        getWeather(with: urlComponents, completion: completion)
    }
    
    private func getBaseComponent() -> URLComponents {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "http"
        urlComponents.host = apiHost
        urlComponents.path = apiPath
        
        let queryItemUnits = URLQueryItem(name: "units", value: "metric")
        let queryItemToken = URLQueryItem(name: "appid", value: appId)
        let queryItemCount = URLQueryItem(name: "cnt", value: "5")
        
        urlComponents.queryItems = [ queryItemUnits, queryItemToken, queryItemCount]
        return urlComponents
    }
    
     func getWeather<T: Decodable>(with components: URLComponents, completion: ((Result<T>) -> Void)?) {
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTP_Methods.get
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, _, error) in
            guard error == nil else { print("ERROR: - \(String(describing: error))"); return}
            guard let jsonData = data else { return }
            print(jsonData)
            print(String(data: jsonData, encoding: .utf8))
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: jsonData)
                completion?(.success(decodedData))
            } catch DecodingError.keyNotFound(let key, let context) {
                fatalError("'\(key.stringValue)' not found – \(context.debugDescription)")
            } catch DecodingError.typeMismatch(_, let context) {
                fatalError("type mismatch – \(context.debugDescription)")
            } catch DecodingError.valueNotFound(let type, let context) {
                fatalError("missing \(type) value – \(context.debugDescription)")
            } catch DecodingError.dataCorrupted(_) {
                fatalError("invalid JSON")
            } catch {
                completion?(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
