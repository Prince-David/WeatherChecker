//
//  WeatherCheckerTests.swift
//  WeatherCheckerTests
//
//  Created by DAVID MAIMAN on 9/13/23.
//

import XCTest
@testable import WeatherChecker

final class WeatherCheckerTests: XCTestCase {
    
    func testWeatherDecoding() {
        let jsonData = """
           {
               "icon": "123",
               "description": "light rain"
           }
           """.data(using: .utf8)!
        
        let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)
        
        XCTAssertNotNil(weather)
        XCTAssertEqual(weather?.icon, "123")
        XCTAssertEqual(weather?.description, "light rain")
    }
    
    func testMainDecoding() {
        let jsonData = """
           {
               "temp": 33.15
           }
           """.data(using: .utf8)!
        
        let main = try? JSONDecoder().decode(Main.self, from: jsonData)
        
        XCTAssertNotNil(main)
        XCTAssertEqual(main?.temp, 33.15)
    }
    
    func testWeatherResponseDecoding() {
        let jsonData = """
           {
               "coord": {"lon": -73.0784, "lat": 40.8123},
               "weather": [{"id": 804, "main": "Clouds", "description": "overcast clouds", "icon": "04d"}],
               "base": "stations",
               "main": {"temp": 66.78, "feels_like": 66.07, "temp_min": 64.06, "temp_max": 69.67, "pressure": 1014, "humidity": 62},
               "visibility": 10000,
               "wind": {"speed": 14.97, "deg": 320, "gust": 24.16},
               "clouds": {"all": 100},
               "dt": 1694877149,
               "sys": {"type": 2, "id": 2001391, "country": "US", "sunrise": 1694860421, "sunset": 1694905263},
               "timezone": -14400,
               "id": 5120987,
               "name": "Holbrook",
               "cod": 200
           }
           """.data(using: .utf8)!
        
        let response = try? JSONDecoder().decode(WeatherResponse.self, from: jsonData)
        
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.main.temp, 66.78)
        XCTAssertEqual(response?.name, "Holbrook")
        XCTAssertEqual(response?.weather.count, 1)
        XCTAssertEqual(response?.weather.first?.icon, "04d")
        XCTAssertEqual(response?.weather.first?.description, "overcast clouds")
    }
    
}
