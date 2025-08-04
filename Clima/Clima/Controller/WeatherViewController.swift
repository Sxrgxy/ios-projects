//
//  ViewController.swift
//  Clima
//
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        print("button pressed")
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assigning this VC as a delegate of a weatherManager struct methods
        weatherManager.delegate = self
            
        // ask a user to use his location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // keybaord in a text field shoud return output to a current VC
        searchTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        //when a search pressed - close a text keboard
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    //text field will answer if we want to process the resut. Hey, VC, the user pressed return on a keyboard, what should we do?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //when a search pressed - close a text keboard
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    //
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            print("textField.text != ''")
//            return true
//        } else {
//            print("textField.text == ''")
//            textField.placeholder = "Type somtheing"
//            return false
//        }
//    }
    
    //when .endEditing method is triggered, this functions is called and it's purpose is run
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        // Use searchTextField.text to get the weather for that city
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    // update UI based on WeatherModel
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            print(weather.conditionName)
        }
    }
    
    func didFailWithError(error: any Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
