//
//  CCSPExportPanelController.swift
//  AppKitBridge
//
//  Created by Steven Troughton-Smith on 26/11/2022.
//  Copyright © 2022 Steven Troughton-Smith. All rights reserved.
//

import AppKit
import UniformTypeIdentifiers

extension NSUserInterfaceItemIdentifier {
	static let exportTypeJPEG = NSUserInterfaceItemIdentifier("jpeg")
	static let exportTypePNG = NSUserInterfaceItemIdentifier("png")
}

// MARK: -

class CCSPExportPanelController: NSObject, NSOpenSavePanelDelegate {
	
	var currentPanel:NSSavePanel? = nil
	let formatPopUpButton = NSPopUpButton(frame: .zero)
	
	func buildSavePanel() -> NSSavePanel {
		let panel = NSSavePanel()
		panel.delegate = self
		
		panel.title = NSLocalizedString("EXPORT_TITLE", comment: "")
		panel.isExtensionHidden = false
		
		let label = NSTextField()
		label.stringValue = NSLocalizedString("EXPORT_FORMAT_LABEL", comment: "")
		label.isEditable = false
		label.isBordered = false
		label.backgroundColor = .clear
		label.alignment = .right
		
		formatPopUpButton.action = #selector(exportTypeDidChange(_:))
		formatPopUpButton.target = self
		
		let menu = NSMenu()
		
		do {
			let item = NSMenuItem(title: NSLocalizedString("EXPORT_TYPE_PNG", comment: ""), action: nil, keyEquivalent: "")
			item.identifier = .exportTypePNG
			menu.addItem(item)
		}
		
		do {
			let item = NSMenuItem(title: NSLocalizedString("EXPORT_TYPE_JPEG", comment: ""), action: nil, keyEquivalent: "")
			item.identifier = .exportTypeJPEG
			menu.addItem(item)
		}
		
		formatPopUpButton.menu = menu
		
		/* Default to first menu item content type */
		panel.allowedContentTypes = [UTType.png] // TODO: Perhaps save the last selected format as a preference

		let horizontallyCenteringStackView = NSStackView()
		
		horizontallyCenteringStackView.alignment = .centerX
		
		let controlStackView = NSStackView()
		
		controlStackView.addArrangedSubview(label)
		controlStackView.addArrangedSubview(formatPopUpButton)
		
		horizontallyCenteringStackView.addArrangedSubview(controlStackView)
		
		panel.accessoryView = horizontallyCenteringStackView
		
		/* Set a fixed height for the accessory view contents */
		
		NSLayoutConstraint.activate([
			controlStackView.heightAnchor.constraint(equalToConstant: 60),
		])
		
		return panel
	}
	
	@objc(presentSavePanelWithName:handler:) func presentSavePanel(withName name:String, handler: @escaping (String, URL) -> Void) {
		
		let panel = buildSavePanel()
		panel.nameFieldStringValue = name

		currentPanel = panel
		
		guard let window = NSApplication.shared.keyWindow else { return }
		
		panel.level = .modalPanel
		panel.beginSheetModal(for: window) { [weak self] response in
			guard let url = panel.url else { return }
			if response == .OK {
				
				/* Fall Back to PNG */
				let type = self?.formatPopUpButton.selectedItem?.identifier?.rawValue ?? "png"
				
				handler(type, url)
			}
		}
	}
	
	@IBAction func exportTypeDidChange(_ sender:NSPopUpButton) {
		guard let type = sender.selectedItem?.identifier else { return }
		
		if type == .exportTypeJPEG {
			currentPanel?.allowedContentTypes = [UTType.jpeg]
		}
		else if type == .exportTypePNG {
			currentPanel?.allowedContentTypes = [UTType.png]
		}
	}
	
}
