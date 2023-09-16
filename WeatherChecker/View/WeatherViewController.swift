//
//  ViewController.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/13/23.
//

import UIKit

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let weatherService = WeatherService()

        weatherService.fetchWeather(for: "Los Angeles") { result in
            switch result {
                case .success(let weather):
                    print("Got weather: \(weather)")
                case .failure(let error):
                    switch error {
                    case .networkError:
                        print("Network error occurred.")
                    case .decodingError:
                        print("Failed to decode the weather data.")
                    case .apiKeyMissing:
                        print("API key is missing.")
                    case .other(let originalError):
                        print("An error occurred: \(originalError.localizedDescription)")
                    }
            }
        }
    }


}

