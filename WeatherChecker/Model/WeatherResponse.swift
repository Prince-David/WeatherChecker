//
//  WeatherResponse.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/16/23.
//

import Foundation
struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}
