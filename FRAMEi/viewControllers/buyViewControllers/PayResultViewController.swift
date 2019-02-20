//
//  PayResultViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 11/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit

class PayResultViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    //get selectedCardList
    var selectedCardList = [cardItem]()
    var selectedOrderList = [Int]()
    
    var orderNumber: UInt?
     var totalPrice: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var orderNumberText: UITextField!
    @IBOutlet weak var totalPriceText: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        // 테이블 데이터 리로드
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //set order Number
        orderNumberText.text = String(orderNumber!)
        
        //set currency formatter.
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        
        //set price.
        totalPriceText.text = currencyFormatter.string(from:NSNumber(value: totalPrice!))
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return selectedCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCardItem = selectedCardList[indexPath.row]
        let orderCardCount = selectedOrderList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "payCell", for: indexPath) as! payCell
        
        cell.titleView.text = orderCardItem.title;
        cell.countView.text = "\(orderCardCount) 장"
        
        
        
        return cell
    }
    
    @IBAction func toMainPressed(_ sender: UIButton) {
      
        //go to main
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
        
    }
    
    
   
}
