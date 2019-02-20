//
//  buttonCustom.swift
//  FRAMEi
//
//  Created by JongHyeok on 11/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit

class buttonCustom: UIButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 3.0
        self.backgroundColor = UIColor(red: 255/255, green: 36/255, blue: 36/255, alpha: 1)
        self.tintColor = UIColor.white
     
    }
    
}
