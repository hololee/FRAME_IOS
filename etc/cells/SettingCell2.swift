//
//  SettingCell
//  FRAMEi
//
//  Created by JongHyeok on 08/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit


protocol SettingCell2Delegate {
    func didButton1Pressed()
    func didButton2Pressed()
}

class SettingCell2: UITableViewCell{
    
     var delegate: SettingCell2Delegate?
    
    var index: Int?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var settingBtn1: UIButton!
    @IBOutlet weak var settingBtn2: UIButton!
    
    
    
    
    
    @IBAction func settingBtn1Pres(_ sender: UIButton) {
        
        switch  index {
        
        case 3:
             delegate?.didButton1Pressed()
        default:
            print("else")
        }
        
    }
    
  
    @IBAction func settingBtn2Pres(_ sender: UIButton) {
        
        switch  index {
       
        case 3:
             delegate?.didButton2Pressed()
        default:
            print("else")
        }
        
    }
    
        
    
        
        
    
    
    
}
