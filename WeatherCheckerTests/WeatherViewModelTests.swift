//
//  WeatherViewModelTests.swift
//  WeatherCheckerTests
//
//  Created by DAVID MAIMAN on 9/16/23.
//

import XCTest
@testable import WeatherChecker

class WeatherViewModelTests: XCTestCase {

    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!

    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
    }

    func testFetchWeatherSuccess() {
        let weatherResponse = WeatherResponse(name: "New City", main: Main(temp: 25.0), weather: [Weather(description: "Clear Sky", icon: "01d")], wind: Wind(speed: 10.0))
        mockWeatherService.weatherResponse = weatherResponse

        viewModel.fetchWeather(for: "New City")

        XCTAssertEqual(viewModel.cityName, "Weather for New City")
        XCTAssertEqual(viewModel.temperature, "25.0°F")
        XCTAssertEqual(viewModel.weatherDescription, "Clear Sky")
        XCTAssertEqual(viewModel.weatherIcon, "01d")
        XCTAssertEqual(viewModel.windSpeed, "Wind 10.0 mph")

    }

    func testFetchWeatherFailure() {
        mockWeatherService.shouldReturnError = true

        viewModel.fetchWeather(for: "Test City")

        // Assuming you have an error state in your ViewModel
        XCTAssertEqual(viewModel.cityName, nil)
    }
}
