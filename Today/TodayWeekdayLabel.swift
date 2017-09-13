//
//  TodayWeekdayLabel.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 9/12/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

import Foundation
import UIKit


class TodayWeekdayLabel : UILabel {
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clear
		self.font = UIFont(name: "HelveticaNeue-Bold", size: 9)
		self.textAlignment = .center
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
