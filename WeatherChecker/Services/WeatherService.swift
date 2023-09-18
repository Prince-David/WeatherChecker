//
//  WeatherService.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/16/23.
//

import Foundation
import Alamofire

enum WeatherError: LocalizedError {
    case networkError
    case decodingError
    case apiKeyMissing
    case other(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "There was an error connecting to the network. Please try again."
        case .decodingError:
            return "There was an error decoding the weather data. Please try again."
        case .apiKeyMissing:
            return "API key is missing. Please check your configuration."
        case .other(let error):
            return error.localizedDescription
        }
    }
}

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, WeatherError>) -> Void)
}

class WeatherService : WeatherServiceProtocol {
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    // In production we should have a backend server make the calls to openweather using the API key
    // so it's not store in the app.
    var apiKey: String? {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return dict["OpenWeatherAPIKey"] as? String
        }
        return nil
    }
    
    //Call the weather service and get results back in imperial units
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, WeatherError>) -> Void) {
        
        guard let apiKey = apiKey else {
            completion(.failure(.apiKeyMissing))
            return
        }
        
        let parameters: [String: Any] = [
            "q": city,
            "appid": apiKey,
            "units" : "imperial"
        ]
        
        AF.request(baseURL, method: .get, parameters: parameters).validate().responseDecodable(of: WeatherResponse.self) { response in
            if let error = response.error {
                completion(.failure(.networkError))
            } else {
                do {
                    let weather = try JSONDecoder().decode(WeatherResponse.self, from: response.data!)
                    completion(.success(weather))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
}
