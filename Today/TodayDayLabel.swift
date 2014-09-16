//
//  TodayDayLabel.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 9/12/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

import Foundation
import UIKit


class TodayDayLabel : UILabel {
	override init() {
		super.init()
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.font =  UIFont(name: "HelveticaNeue-Bold", size: 12)
		self.textAlignment = .Center
		self.contentMode = .Center
	}
	
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
