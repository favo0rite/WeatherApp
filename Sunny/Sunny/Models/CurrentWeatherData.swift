//
//  CurrentWeatherData.swift
//  Sunny
//
//  Created by out-zamotaev-pk on 21.09.2021.
//  Copyright © 2021 Ivan Akulov. All rights reserved.
//

import Foundation

struct CurrentWeatherData: Codable {
	let name: String
	let main: Main
	let weather: [Weather]

	struct Main: Codable {
		let temp: Double
		let feelslike: Double
	
		enum CodingKeys: String, CodingKey {
			case temp
			case feelslike = "feels_like"
		}
	}

	struct Weather: Codable {
		let id: Int
	}
}
