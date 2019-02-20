//
//  PayViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 11/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit
import SwiftyBootpay
import Toast_Swift

class PayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BootpayRequestProtocol{
   
   
    var vc: BootpayController!
    var vcSetted: BootpayController?

    //get selectedCardList
    var selectedCardList = [cardItem]()
    var selectedOrderList = [Int]()
    
    var orderNumber: UInt?
    
    var firstLoaded: Bool = true
    
    
    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var phoneBox: UITextField!
    @IBOutlet weak var addressBox: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cardValue: UILabel!
    @IBOutlet weak var delivValue: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    
    var totalCardPrice: Int = 0
    var totalPrice: Int = 0
    
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 테이블 데이터 리로드
        self.tableView.reloadData()
        
        //clear price.
        totalCardPrice = 0
        totalPrice = 0
        
        //set user info
        nameBox.text = UserDefaults.standard.string(forKey: "name")
        phoneBox.text = UserDefaults.standard.string(forKey: "phone")
        addressBox.text = UserDefaults.standard.string(forKey: "address")
        
        print("selected cards count : \(selectedCardList.count)")
        
        
        //set currency formatter.
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        
        //set card price.
        for i in 0..<selectedCardList.count{
            totalCardPrice += 500 * selectedOrderList[i]
        }
        cardValue.text = currencyFormatter.string(from: NSNumber(value: totalCardPrice))
        
        //set delivary price.
        if totalCardPrice > 30000 {
            //3만원 이상 무료배송.
               delivValue.text = String(0)
        }else{
            delivValue.text = currencyFormatter.string(from: NSNumber(value: 3000))
        }
        
        
        //set totalPrice.
        totalPrice = totalCardPrice + 3000
        
        totalValue.text = currencyFormatter.string(from: NSNumber(value: totalPrice))
        
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        
        if firstLoaded {
            
            firstLoaded = false
            
            //show notice.
            let dialog = UIAlertController(title: "알림", message: "3만원 이상은 무료배송입니다.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
            dialog.addAction(action)
            self.present(dialog, animated: true, completion: nil)
        }
    }
    
   
    
    
    @IBAction func payBtnPressed(_ sender: UIButton) {
        
        
        let dialog = UIAlertController(title: "주문정보 확인", message: "주문정보를 확인하였나요?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "네", style: UIAlertAction.Style.destructive){ (action: UIAlertAction) -> Void in
            
            // 결제 시작.
            print("process start")
            self.goBuy()
        }
        
        let action2 = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default)
        
        dialog.addAction(action1)
        dialog.addAction(action2)
        
        self.present(dialog, animated: true, completion: nil)
        
        
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
    
    func onError(data: [String : Any]) {
         print("onError")
         vcSetted?.dismiss(animated: true, completion: nil)
    }
    
    func onReady(data: [String : Any]) {
         print("onReady")
        self.view.makeToast("가상계좌 발급이 완료되었습니다.")
        vcSetted?.dismiss(animated: true, completion: nil)
        
        let payResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "payResult") as! PayResultViewController
        payResultViewController.selectedOrderList = self.selectedOrderList
        payResultViewController.selectedCardList = self.selectedCardList
        payResultViewController.orderNumber = self.orderNumber
        payResultViewController.totalPrice = self.totalPrice
        self.present(payResultViewController, animated: true, completion: nil)
        
        
    }
    
    func onClose() {
         print("onClose")
         vcSetted?.dismiss(animated: true, completion: nil)
       
        
    }
    
    func onConfirm(data: [String : Any]) {
        
        print("onConfirm")
         vcSetted?.transactionConfirm(data: data)
        
    }
    
    func onCancel(data: [String : Any]) {
         print("onCancel")
         self.view.makeToast("결제가 취소되었습니다.")
         vcSetted?.dismiss(animated: true, completion: nil)
    }
    
    func onDone(data: [String : Any]) {
         print("onDone")
        //결제 완료

        self.view.makeToast("결제가 완료되었습니다.")
        
        vcSetted?.dismiss(animated: true, completion: nil)
        
        let payResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "payResult") as! PayResultViewController
        payResultViewController.selectedOrderList = self.selectedOrderList
        payResultViewController.selectedCardList = self.selectedCardList
        payResultViewController.orderNumber = self.orderNumber
        payResultViewController.totalPrice = self.totalPrice
        self.present(payResultViewController, animated: true, completion: nil)

    }
    
    
    
    
    //go to pay
    func goBuy() {
        // 통계정보를 위해 사용되는 정보
        // 주문 정보에 담길 상품정보로 배열 형태로 add가 가능함
        
        let item1 = BootpayItem().params {
            $0.item_name = "FRAME CARD" // 주문정보에 담길 상품명
            $0.qty = selectedCardList.count // 해당 상품의 주문 수량
            $0.unique = "ITEM_CARDS" // 해당 상품의 고유 키
            $0.price = 500 // 상품의 가격
        }
        
        let item2 = BootpayItem().params {
            $0.item_name = "FRAME DELIVERY PREMIUM" // 주문정보에 담길 상품명
            $0.qty = 1 // 해당 상품의 주문 수량
            $0.unique = "DELIVERY_PREMIUM" // 해당 상품의 고유 키
            $0.price = 3000 // 상품의 가격
        }
        
        // 구매자 정보
        let userInfo: [String: String] = [
            "username": UserDefaults.standard.string(forKey: "name")!,
            "email": "",
            "addr": UserDefaults.standard.string(forKey: "address")!,
            "phone": UserDefaults.standard.string(forKey: "phone")!
        ]
        
        vc = BootpayController()
        
        // 주문정보 - 실제 결제창에 반영되는 정보
         vcSetted = vc.params {
            $0.price = Double(totalPrice)// 결제할 금액
            $0.name = "\(orderNumber!) P. \(selectedCardList.count)" // 결제할 상품명
            $0.order_id = String(orderNumber!) //고유 주문번호로, 생성하신 값을 보내주셔야 합니다.
            $0.user_info = userInfo // 구매자 정보
            $0.pg = "kcp" // 결제할 PG사
            $0.phone = UserDefaults.standard.string(forKey: "phone")! // 구매자 번호
            $0.sendable = self // 이벤트를 처리할 protocol receiver
            $0.quotas = [0]
        }
        
        vcSetted!.addItem(item: item1) //배열 가능
        vcSetted!.addItem(item: item2)
        
        self.present(vcSetted!, animated: true, completion: nil) // 결제창 controller 호출
     
    }
}


