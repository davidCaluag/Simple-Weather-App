//
//  MyStandaloneClasses.swift
//  DavidWeather
//
//  Created by David C on 2024-11-08.
//

import Foundation
import UIKit

class NotificationAlert {
	static func show(title: String, message: String, on viewController: UIViewController? = getRootViewController()) {
		guard let viewController = viewController else {
			print("⚠️ No root view controller found to present the alert.")
			return
		}

		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

		viewController.present(alert, animated: true, completion: nil)
	}

	// Helper function to get the root view controller in a compatible way for iOS 15+
	private static func getRootViewController() -> UIViewController? {
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			  let rootViewController = windowScene.windows.first?.rootViewController else {
			return nil
		}
		return rootViewController
	}
}
