//
//  ViewController.swift
//  WeatherChecker
//
//  Created by DAVID MAIMAN on 9/13/23.
//

import UIKit
import SDWebImage
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblConditions: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var txtCity: UITextField!
    
    private var viewModel: WeatherViewModel!
    let locationManager = CLLocationManager()
    var currentCity: String?
    var shouldProcessLocationUpdates = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        txtCity.delegate = self
        
        //Setup label fields
        lblCity.text = ""
        lblTemp.text = ""
        lblConditions.text = ""
        
        viewModel = WeatherViewModel(weatherService: WeatherService())
        
        //Assign functions for receiving data or error from the WeatherService
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
        
        if let lastCity = UserDefaults.standard.string(forKey: "lastSearchedCity") {
            viewModel.fetchWeather(for: lastCity)
        }
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
    
    @IBAction func touchCurrentLocation(_ sender: Any) {
        if let city = currentCity {
            //Call fetch weather on the currentCity fetched from CoreLocation
            viewModel.fetchWeather(for: city)
        } else {
            shouldProcessLocationUpdates = true
            // Request permission
            locationManager.requestWhenInUseAuthorization()
            // If authorized, get location
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                //Force a location update when authorized
                locationManager.stopUpdatingLocation()
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Delegate method when locations are updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Don't process location updates when first starting app, wait until button pressed
        guard shouldProcessLocationUpdates else { return }
        
        if let location = locations.last {
            determineCity(from: location)
        }
    }
    
    // Delegate method when location request fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showErrorAlert(withMessage: "Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func determineCity(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showErrorAlert(withMessage: "Failed to determine city: \(error.localizedDescription)")
                }
                return
            }
            if let placemark = placemarks?.first, let city = placemark.locality {
                self?.viewModel.fetchWeather(for: city)
                self?.currentCity = city
                self?.locationManager.stopUpdatingLocation()
                self?.shouldProcessLocationUpdates = false
            }
        }
    }
    
}

