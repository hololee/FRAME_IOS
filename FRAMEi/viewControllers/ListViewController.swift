//
//  ListViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 07/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buyBtn: UIButton!
    
    
    //get cards list from DataBase.
    var cardList = [cardItem]()
    
    //  뷰가 화면에 출력되면 호출
    override func viewWillAppear(_ animated: Bool) {
        
        let dataBaseManager = DatabaseManager()
        //open database.
        dataBaseManager.initDatabase()
        
        //init card list.
        cardList.removeAll();
        //get card lists
        cardList = dataBaseManager.getAllCardData()
        
        
        //close database.
        dataBaseManager.closeDatabase()
        
        // 테이블 데이터 리로드
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        //setup long press cell.
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ListViewController.longPressCalled))
        tableView.addGestureRecognizer(longPressGesture)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    
    // MARK: - Table view data source
    // 테이블 뷰의 셀 개수를 결정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    // 개별 행을 구성하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        // memolist 배열에서 주어진 행에 맞는 데이터를 꺼냄
        let row = cardList[indexPath.row]
        
        // 이미지 속성이 비어 있고 없고에 따라 프로토타입 셀 식별자를 변경
        let cellId = "cardCell"
        
        // 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달 받음
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainCell
        
        // 내용 구성
        cell.titleView?.text = row.title
        cell.dateView?.text = row.regdate
        
        
        return cell
    }
    
    
    // 테이블 행을 선택하면 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectdCard = cardList[indexPath.row]
       // print("\(String(selectdCard.cardId!)) | \(selectdCard.image!) | \(selectdCard.title!) | \(selectdCard.regdate!) | \(selectdCard.content!)")
        
        
        //sendoriginal card data.
        let showViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowCardView") as! ShowCardViewController
        
        showViewController.allCardList = cardList
        showViewController.originalCard = selectdCard
        showViewController.index = indexPath.row
        
        let sections: Int = tableView.numberOfSections
        var rows: Int = 0
        
        for i in 0..<sections {
            rows += tableView.numberOfRows(inSection: i)
        }
        
        showViewController.total = rows
        present(showViewController, animated: true, completion: nil)
        
        
        
    }
    
    
    // when long click cell.
    @objc func longPressCalled(_ longPress: UILongPressGestureRecognizer) {
        print("longPressCalled")
        
        //indexPath
        let locationInView = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        
        
        // prevent other side long click.
        if indexPath != nil {
            let selectedCard = cardList[(indexPath?.row)!]
            
            //print("\(String(selectedCard.cardId!)) | \(selectedCard.image!) | \(selectedCard.title!) | \(selectedCard.regdate!) | \(selectedCard.content!)")
            
            
            // open edit Page.
            //sendoriginal card data.
            let editViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditView") as! EditViewController
            editViewController.originalCard = selectedCard
            present(editViewController, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    
    // buy cards.
    @IBAction func buyBtnPressed(_ sender: Any) {
        
        
        
        //check UserInfo.
        let savedUserName = UserDefaults.standard.string(forKey: "name") as NSString?
        let savedUserPhone = UserDefaults.standard.string(forKey: "phone") as NSString?
        let savedUserAddress = UserDefaults.standard.string(forKey: "address") as NSString?
        
        if savedUserName != nil && savedUserPhone != nil && savedUserAddress != nil  {
            //value exists.
            
            
            if savedUserName!.length > 0 && savedUserPhone!.length > 0 && savedUserAddress!.length > 0 {
                //user data exists.
                
                //move to buy Page..
                let buyViewController = self.storyboard?.instantiateViewController(withIdentifier: "buyView") as! BuyViewController
                buyViewController.cardList = cardList
                present(buyViewController, animated: true, completion: nil)
                
            }else{
                
                //확인 알림창 띄우기.
                let dialog = UIAlertController(title: "사용자 정보", message: "설정에서 사용자 정보를 입력해주세요.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                
                dialog.addAction(action)
              
                self.present(dialog, animated: true, completion: nil)
            }
            
            
        }else{
            
            //확인 알림창 띄우기.
            let dialog = UIAlertController(title: "사용자 정보", message: "설정에서 사용자 정보를 입력해주세요.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
            
            dialog.addAction(action)
            
            self.present(dialog, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    @IBAction func goBacks(_ sender: UIButton) {
        
        
        performSegue(withIdentifier: "backMain", sender: self)
        
    }
    
    @IBAction func unwindToAdd(segue:UIStoryboardSegue) {
        
        
        
    }
}
