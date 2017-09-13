//
//  ColorViewController.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 10/28/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

import Foundation
import UIKit


protocol ColorViewControllerDelegate {
	func colorView(_ colorView: ColorViewController, didSelectColor: UIColor);
}


class ColorViewController : UIViewController {
	var color: UIColor! = UIColor.black
	
	var _delegate: ColorViewControllerDelegate!
	var _colorPickerView: HRColorPickerView!
	
	
	init(delegate: ColorViewControllerDelegate, color: UIColor! = nil) {
		super.init(nibName: nil, bundle: nil)
		
		self.edgesForExtendedLayout = UIRectEdge()
		
		_delegate = delegate
		self.color = color
	}
	
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_colorPickerView = HRColorPickerView(frame: self.view.bounds)
		_colorPickerView.color = self.color
		_colorPickerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.addSubview(_colorPickerView)
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		_delegate.colorView(self, didSelectColor: _colorPickerView.color)
	}
}
