//
//  DatePickAlertViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 08/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit

class DatePickAlertViewController: UIViewController{
    
    
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var selectBtn: UIButton!
    
    var selectedDate : Date?
    var delegate: selectedDateDelegate?
    
    var isSelected = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
      selectedDate = Date()

        
    }
    
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        
         selectedDate = sender.date
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if isSelected {
            //when selectBtn clicked
              delegate?.providerSent(selectedDate!)
            
        }
      
    }
    
    
    
    //push cancel button
    @IBAction func onClickCancel(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickSelect(_ sender: Any) {
        
        isSelected = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
