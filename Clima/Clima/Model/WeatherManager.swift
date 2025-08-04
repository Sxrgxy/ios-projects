//
//  WeatherManager.swift
//  Clima
//
//  Created by dev on 27.07.2025.
//

import Foundation
import CoreLocation

// separate functions that can be added to a struct or class and a called protocol can act as a delegate
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=f4a3f17ce35f86ccd2356882c0c8ad8a"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }

    
    func performRequest(with urlString: String) {
        //1.Create URL
        if let url = URL(string: urlString) {
            //2.Create a URL session
            let session = URLSession(configuration: .default)
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, url, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return //exit out of this function
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        // update ViewController with delegate
                        // I need to make smth a delegate of another thing VC is delegate of WM, or vice versa
                        // Kind of a WM should be a delegate?
                        // delegate = self
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4.Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            // WeatherData.self returns a type of WeatherData, a Decodable
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            weather.conditionName
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
