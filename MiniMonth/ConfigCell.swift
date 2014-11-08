//
//  ConfigCell.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 11/7/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

import Foundation
import UIKit


class ConfigCell : UITableViewCell {
	var _configKey: String!
	var _colorView: UIView!
	
	
	init(configKey: String) {
		super.init(style: .Default, reuseIdentifier: nil)
		
		_configKey = configKey
		
		_colorView = UIView()
		_colorView.layer.cornerRadius = 10
		self.contentView.addSubview(_colorView)
	}
	
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let defs = NSUserDefaults(suiteName: "group.me.bronenos.minimonth")!
		let hex2color = TodayViewController.hexToColor
		_colorView.backgroundColor = hex2color(defs.objectForKey(_configKey) as String)
		
		var rect = self.contentView.bounds
		rect.origin.x = rect.size.width - 20
		rect.origin.y = (rect.size.height - 20) * 0.5
		rect.size.width = 20
		rect.size.height = 20
		_colorView.frame = rect
	}
}
