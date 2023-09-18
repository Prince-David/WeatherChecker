//
//  MockWeatherService.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/16/23.
//

import Foundation

//Mock the Weather Service for use in unit testing
class MockWeatherService: WeatherServiceProtocol {
    var shouldReturnError = false
    var weatherResponse: WeatherResponse?

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, WeatherError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.networkError))
        } else if let weatherResponse = weatherResponse {
            completion(.success(weatherResponse))
        } else {
            fatalError("Error: You must set either 'shouldReturnError' or 'weatherResponse' before running the test")
        }
    }
}
