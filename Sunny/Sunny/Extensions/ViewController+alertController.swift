//
//  ViewController+alertController.swift
//  Sunny
//
//  Created by out-zamotaev-pk on 21.09.2021.
//  Copyright © 2021 Ivan Akulov. All rights reserved.
//

import UIKit

extension ViewController {
	func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: style)
		ac.addTextField { tf in
			let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
			tf.placeholder = cities.randomElement()
		}
		let search = UIAlertAction(title: "Search", style: .default) { action in
			let textField = ac.textFields?.first
			guard let cityName = textField?.text else { return }
			if cityName != "" {
				let city = cityName.split(separator: " ").joined(separator: "%20")
				completionHandler(city)
			}
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		ac.addAction(search)
		ac.addAction(cancel)
		present(ac, animated: true, completion: nil)
	}
}
