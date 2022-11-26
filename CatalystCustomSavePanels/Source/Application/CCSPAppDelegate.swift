//
//  CCSPAppDelegate.swift
//  CatalystCustomSavePanels
//
//  Created by Steven Troughton-Smith on 26/11/2022.
//  
//

import UIKit

@UIApplicationMain
class CCSPAppDelegate: UIResponder, UIApplicationDelegate {
	
	func loadAppKitBridgeIfNeeded() {
#if targetEnvironment(macCatalyst)
		
		if let frameworksPath = Bundle.main.privateFrameworksPath {
			let bundlePath = "\(frameworksPath)/AppKitBridge.framework"
			do {
				try Bundle(path: bundlePath)?.loadAndReturnError()
				
				_ = Bundle(path: bundlePath)!
				NSLog("[APPKIT BUNDLE] Loaded Successfully")
			
			}
			catch {
				NSLog("[APPKIT BUNDLE] Error loading: \(error)")
			}
		}
		
#endif
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		loadAppKitBridgeIfNeeded()
		
		return true
	}
}
