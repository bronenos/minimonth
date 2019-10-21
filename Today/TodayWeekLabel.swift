//
//  TodayWeekLabel.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Foundation
import UIKit

class TodayWeekLabel : UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font =  UIFont(name: "HelveticaNeue", size: 8)
        self.textAlignment = .center
        self.contentMode = .center
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
