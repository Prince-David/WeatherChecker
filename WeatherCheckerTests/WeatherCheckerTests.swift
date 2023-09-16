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
               "name": "New York",
               "weather": [{
                   "icon": "123",
                   "description": "light rain"
               }],
               "main": {
                   "temp": 33.15
               }
           }
           """.data(using: .utf8)!
        
        let response = try? JSONDecoder().decode(WeatherResponse.self, from: jsonData)
        
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.main.temp, 33.15)
        XCTAssertEqual(response?.name, "New York")
        XCTAssertEqual(response?.weather.count, 1)
        XCTAssertEqual(response?.weather[0].icon, "123")
        XCTAssertEqual(response?.weather[0].description, "light rain")
    }
    
}
