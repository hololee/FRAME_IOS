//
//  selectCell.swift
//  FRAMEi
//
//  Created by JongHyeok on 11/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit


protocol SelectCellDelegate {
    func subBtnPressed(index: Int, currentCount: Int)
    func addBtnPressed(index: Int, currentCount: Int)
}


class selectCell:UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var delegate: SelectCellDelegate?
    
    
    var currentIndex: Int?
    var currentCount: Int = 0
    

    @IBAction func subBtnPressed(_ sender: UIButton) {
        
        if currentCount > 0 {
            currentCount -= 1
            countLabel.text = String(currentCount)
            delegate?.subBtnPressed(index: currentIndex!, currentCount: currentCount)
        }

    }
    @IBAction func addBtnPressed(_ sender: UIButton) {
        currentCount += 1
        countLabel.text = String(currentCount)
         delegate?.addBtnPressed(index: currentIndex!, currentCount: currentCount)
        
    }
}
