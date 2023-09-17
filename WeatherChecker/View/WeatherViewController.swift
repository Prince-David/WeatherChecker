//
//  ViewController.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/13/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var txtCity: UITextField!
    private var viewModel: WeatherViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WeatherViewModel(weatherService: WeatherService())
        
        viewModel.didUpdateWeather = { [weak self] in
            print(self?.viewModel.cityName)
            print(self?.viewModel.temperature)
        }
        
        viewModel.didEncounterError = { [weak self] error in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func touchSearch(_ sender: Any) {
        if let city = txtCity.text {
            viewModel.fetchWeather(for: city)
        }
    }
    
}

