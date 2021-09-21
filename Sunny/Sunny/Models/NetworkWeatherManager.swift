//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by out-zamotaev-pk on 21.09.2021.
//  Copyright © 2021 Ivan Akulov. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {

	enum RequestType {
		case cityName(city: String)
		case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
	}
	
	var onCompletion: ((CurrentWeather) -> Void)?

	func fetchCurrentWeather(requestType: RequestType) {
		var urlString = ""
		switch requestType {
		case .cityName(let city):
			urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
		case . coordinate(latitude: let latitude, longitude: let longitude):
			urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apikey=\(apiKey)&units=metric"
		}
		
		performRequest(withURLString: urlString)
	}

	fileprivate func performRequest(withURLString urlString: String) {
		guard let url = URL(string: urlString) else { return }
		let session = URLSession(configuration: .default)
		let task = session.dataTask(with: url) { data, response, error in
			if let data = data {
				if let currentWeather = self.parseJSON(withData: data) {
					self.onCompletion?(currentWeather)
				}
			}
		}
		task.resume()
	}
	
	fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
		let decoder = JSONDecoder()
		do {
			let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
			guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
				return nil
			}
			return currentWeather
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		return nil
	}
}
