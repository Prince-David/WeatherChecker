//
//  WeatherService.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/16/23.
//

import Foundation
import Alamofire

enum WeatherError: Error {
    case networkError
    case decodingError
    case apiKeyMissing
    case other(Error)
}

class WeatherService {
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    var apiKey: String? {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return dict["OpenWeatherAPIKey"] as? String
        }
        return nil
    }
    
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
