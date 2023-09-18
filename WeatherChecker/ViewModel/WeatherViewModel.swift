//
//  WeatherViewModel.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/16/23.
//

import Foundation

class WeatherViewModel {
    
    private var weatherService: WeatherServiceProtocol
    
    //There is more data we could display but for now we are keeping it simple
    var cityName: String?
    var temperature: String?
    var weatherDescription: String?
    var weatherIcon: String?
    var windSpeed: String?
    
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
                self?.windSpeed = "Wind \(weatherResponse.wind.speed) mph"
                //Store the last successfully searched for city
                UserDefaults.standard.set(city, forKey: "lastSearchedCity")
                
                // Inform the WeatherViewController that the data is ready for display
                self?.didUpdateWeather?()
                
            case .failure(let error):
                self?.didEncounterError?(error)
            }
        }
    }
}
