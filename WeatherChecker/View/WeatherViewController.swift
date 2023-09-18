//
//  ViewController.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/13/23.
//

import UIKit
import SDWebImage

class WeatherViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblConditions: UILabel!
    
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var txtCity: UITextField!
    private var viewModel: WeatherViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCity.delegate = self
        
        lblCity.text = ""
        lblTemp.text = ""
        lblConditions.text = ""
        viewModel = WeatherViewModel(weatherService: WeatherService())
        
        viewModel.didUpdateWeather = { [weak self] in
            self?.lblCity.text = self?.viewModel.cityName ?? ""
            self?.lblTemp.text = self?.viewModel.temperature ?? ""
            self?.lblConditions.text = self?.viewModel.weatherDescription ?? ""
            if let img = self?.viewModel.weatherIcon {
                let imageUrl = "https://openweathermap.org/img/wn/" + img + "@2x.png"
                self?.imgWeather.sd_imageIndicator = SDWebImageActivityIndicator.white
                self?.imgWeather.sd_setImage(with: URL(string: imageUrl))
            }

        }
        
        viewModel.didEncounterError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert(withMessage: error.localizedDescription)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    func showErrorAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func touchSearch(_ sender: Any) {
        dismissKeyboard()
        if let city = txtCity.text {
            lblCity.text = ""
            lblTemp.text = ""
            lblConditions.text = ""
            viewModel.fetchWeather(for: city)
            txtCity.text = ""
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

