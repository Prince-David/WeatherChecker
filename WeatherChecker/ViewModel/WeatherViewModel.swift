//
//  WeatherViewModel.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/16/23.
//

import Foundation

class WeatherViewModel {
    
    private var weatherService: WeatherServiceProtocol
    
    var cityName: String?
    var temperature: String?
    var weatherDescription: String?
    var weatherIcon: String?
    
    var didUpdateWeather: (() -> Void)?
    var didEncounterError: ((WeatherError) -> Void)?

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(for city: String) {
        weatherService.fetchWeather(for: city) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                //Format the text for use in the UI
                self?.cityName = "Weather for " + weatherResponse.name
                self?.temperature = "\(weatherResponse.main.temp)°F"
                self?.weatherDescription = weatherResponse.weather.first?.description.capitalized
                self?.weatherIcon = weatherResponse.weather.first?.icon
                UserDefaults.standard.set(city, forKey: "lastSearchedCity")
                print(UserDefaults.standard.string(forKey: "lastSearchedCity"))
                // Inform the WeatherViewController that the data is ready for display
                self?.didUpdateWeather?()
                
            case .failure(let error):
                self?.didEncounterError?(error)
            }
        }
    }
}
