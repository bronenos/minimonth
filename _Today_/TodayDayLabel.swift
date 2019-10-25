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
	var _pointColor: UIColor!
	var pointColor: UIColor! {
		get { return _pointColor }
		set { _pointColor = newValue }
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.font =  UIFont(name: "HelveticaNeue-Bold", size: 12)
		self.textAlignment = .center
		self.contentMode = .center
	}
	
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		if _pointColor != nil {
			var r = rect
			r.origin.y = r.size.height - 2
			r.size.height = 2
			r.origin.x += r.size.width * 0.5 - 1
			r.size.width = 2
			
			_pointColor.set()
			UIRectFill(r)
		}
	}
}
