//
//  CCSPMainViewController.swift
//  CatalystCustomSavePanels
//
//  Created by Steven Troughton-Smith on 26/11/2022.
//  
//

import UIKit
import AppleUniversalCore

// MARK: AppKit Bridge Interface

extension NSObject {
	@objc(presentSavePanelWithName:handler:) func presentSavePanel(withName name:String, handler: @escaping (String, URL) -> Void) {
		
	}
}

// MARK: -

final class CCSPMainViewController: UIViewController {
	
	var currentAppKitSaveController:NSObject? = nil
	
	let button = {
		let button = UIButton(type: .system)
		button.setTitle(NSLocalizedString("BUTTON_EXPORT", comment: ""), for: .normal)
		
		return button
	} ()
	
	var dummyImage = {
		let size = CGSize(width: 512, height: 512)
		let renderer = UIGraphicsImageRenderer(size: size, format: UIGraphicsImageRendererFormat(for: UITraitCollection(displayScale: 1.0)))
		
		let image = renderer.image { context in
			UIColor.systemRed.setFill()
			UIRectFill(CGRect(origin: .zero, size: size))
		}
		
		return image
	}()
	
	// MARK: -

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "CatalystCustomSavePanels"
		
		button.addTarget(self, action: #selector(doExport(_:)), for: .touchUpInside)
		view.addSubview(button)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	// MARK: - Layout
	
	override func viewDidLayoutSubviews() {
		
		let safeFrame = view.bounds.inset(by: view.safeAreaInsets)
		
		button.sizeToFit()
		button.frame = button.bounds.centered(in: safeFrame)
	}
	
	// MARK: - Actions
	
	@objc func doExport(_ sender:Any?) {
		if let c = NSClassFromString("AppKitBridge.CCSPExportPanelController") as? NSObject.Type {
			let controller = c.init()
			
			/* Saving a temporary reference to the controller or it
			 may be released before it wires up the popup button actions */
			
			currentAppKitSaveController = controller
			
			controller.presentSavePanel(withName:"My File") { [weak self] type, url in
				NSLog("[APPKIT] Bridging save of \(type) to \(url.absoluteString) from \(controller)")

				/* Remove existing item */
				try? FileManager.default.removeItem(at: url)
				
				if type == "jpeg" {
					if let data = self?.dummyImage.jpegData(compressionQuality: 0.7) {
						try? data.write(to: url)
					}
				}
				else if type == "png" {
					if let data = self?.dummyImage.pngData() {
						try? data.write(to: url)
					}
				}
				
			}
		}

	}
}
