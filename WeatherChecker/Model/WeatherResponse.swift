//
//  WeatherResponse.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/16/23.
//

import Foundation

//In all models just retrieving relevant simple data to show the user
struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}
