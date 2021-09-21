//
//  ViewController.swift
//  Sunny
//
//  Created by out-zamotaev-pk on 21.09.2021.
//  Copyright © 2021 Ivan Akulov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
	
	@IBOutlet weak var weatherIconImageView: UIImageView!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
	
	var networkWeatherManager = NetworkWeatherManager()
	lazy var locationManager: CLLocationManager = {
		let lm = CLLocationManager()
		lm.delegate = self
		lm.desiredAccuracy = kCLLocationAccuracyBest
		lm.requestWhenInUseAuthorization()
		return lm
	}()
	
	@IBAction func searchPressed(_ sender: UIButton) {
		self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { city in
			self.networkWeatherManager.fetchCurrentWeather(requestType: .cityName(city: city))
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showWeather()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager.requestLocation()
		}

	}

	func showWeather() {
		networkWeatherManager.onCompletion = { currentWeather in
			self.updateInterface(weather: currentWeather)
		}
	   }
	
	func updateInterface(weather: CurrentWeather) {
		DispatchQueue.main.async {
			self.cityLabel.text = weather.cityName
			self.temperatureLabel.text = weather.temperatureString
			self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
			self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
		}
	}
}

extension ViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		let latitude = location.coordinate.latitude
		let longitude = location.coordinate.longitude
	
		networkWeatherManager.fetchCurrentWeather(requestType: .coordinate(latitude: latitude, longitude: longitude))
		
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
}


