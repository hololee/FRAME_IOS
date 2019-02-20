//
//  BuyViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 11/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit
import Kingfisher
import ZIPFoundation
import Toast_Swift
import Alamofire

class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //get cards list from MainListView
    var cardList = [cardItem]()
    var orderList = [Int]()

    //init nil
    var selectedCardList = [cardItem]()
    var selectedOrderList = [Int]()
    
    var orderNumber: UInt = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        // 테이블 데이터 리로드
        self.tableView.reloadData()
        
        //clear data.
         selectedCardList.removeAll()
         selectedOrderList.removeAll()
    }
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        //create order data.
        orderList = [Int](repeating: 0, count: cardList.count)
        
    }

    
    
    // MARK: - Table view data source
    // 테이블 뷰의 셀 개수를 결정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    // 개별 행을 구성하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        // memolist 배열에서 주어진 행에 맞는 데이터를 꺼냄
        let card = cardList[indexPath.row]
        
        // 이미지 속성이 비어 있고 없고에 따라 프로토타입 셀 식별자를 변경
        let cellId = "selectCell"
        
        // 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달 받음
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! selectCell
        
        //set delegate
        cell.delegate = self
        
        //set index.
        cell.currentIndex = indexPath.row
        cell.titleLabel.text = card.title
        cell.countLabel.text = String(orderList[indexPath.row])
        
        
        return cell
    }
    
    
    
    //send cards throught email.
    @IBAction func sned(_ sender: UIButton) {
        
        
        
        var selectCounts = 0
        
        //create cards.
        for i in 0..<self.cardList.count{
            
            if self.orderList[i] > 0 { //if card selected
                selectCounts += 1
            }
            
        }
        
        
        //선택된 카드 종류를 확인해서 1~20 개 사이만 선택가능.
        if selectCounts > 0 && selectCounts <= 20 {
            
            //create order Number.
            self.orderNumber = (UInt(Date().timeIntervalSince1970 * 1000) / 2) + UInt((arc4random_uniform(20000) + 1))
            print(String(self.orderNumber))
            
            
            
            //show loading dialog.
            self.view.addSubview(UIView().customActivityIndicator(view: self.view, widthView: nil))
            //hide loading dialog.
            //self.view.hideLoader(removeFrom: self.view)
            
            
            //create cover image before show loading alert beacuse of running on main thread.
            //create cover card.
            self.createCoverAndSave()
            
            
            let g = DispatchGroup()
            let q1 = DispatchQueue(label: "queue1")
            
            
            q1.async(group: g) {
                //start sendEmail.
                

                //create cards.
                for i in 0..<self.cardList.count{
                    
                    if self.orderList[i] > 0 { //if card selected
                        //create cards.
                        self.createImageAndSave(cardItem: self.cardList[i], count: self.orderList[i])
                        
                        //add in selectd card list.
                        self.selectedCardList.append(self.cardList[i])
                        self.selectedOrderList.append(self.orderList[i])
                        
                    }
                    
                }
                
                //save data file.
                self.creatOrderDataAndSave()
                
                
                //zip upload folder
                let fileManager = FileManager()
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let sourceURL = documentsDirectory!.appendingPathComponent("MM/images/upload")
                
                let destinationURL = documentsDirectory!.appendingPathComponent("MM/images/cards_data.zip")
                
                do {
                    try fileManager.zipItem(at: sourceURL, to: destinationURL)
                    if  FileManager.default.fileExists(atPath: destinationURL.path) {
                        print("zip succeed")
                        
                        
                        //send data.
                        //let fileURL = Bundle.main.url(forResource: "video", withExtension: "mov")
                        
                        AF.upload(multipartFormData: {multipartFormData in
                            multipartFormData.append(destinationURL, withName: "data")
                            multipartFormData.append(String(self.orderNumber).data(using: .utf8)!, withName: "name")
                            
                        }, to: "http://lccandol.cafe24.com/imageUpload.php").response{ response in
                            
                            switch response.result {
                            case .success(let data):
                                if (String(data: data!, encoding: .utf8)! == "success"){
                                    
                                    //close dialog
                                    self.view.hideLoader(removeFrom: self.view)
                                    
                                    //move to pay page. with cardList, orderList
                                    let payViewController = self.storyboard?.instantiateViewController(withIdentifier: "payView") as! PayViewController
                                    payViewController.selectedOrderList = self.selectedOrderList
                                    payViewController.selectedCardList = self.selectedCardList
                                    payViewController.orderNumber = self.orderNumber
                                    self.present(payViewController, animated: true, completion: nil)
                                    
                                    //delete upload folder and delete card_data.zip
                                    self.clearUploadFile()
                                    
                                    
                                }else if (String(data: data!, encoding: .utf8)! == "fail"){
                                    self.view.makeToast("업로드중 오류가 발생했습니다.\n다시 시도해주세요.")
                                }
                                
                            case .failure:
                                self.view.makeToast("알수없는 오류가 발생했습니다.\nframe_service@naver.com 으로 알려주세요!")
                            }
                            
                        }
                        
                        
                    }
                } catch {
                    print("Creation of ZIP archive failed with error:\(error)")
                     self.view.makeToast("알수없는 오류가 발생했습니다.\nframe_service@naver.com 으로 알려주세요!")
                }
                
                
             
            }
            
            g.notify(queue: DispatchQueue.main) {
         
            }
            
            
        }else{
            self.view.makeToast("최대 20개의 카드를 선택하실 수 있습니다.")
        }
    
    }
    
    

    
  
    
    //clear upload folder and file.
    func clearUploadFile(){
        //file path if exists
        let fileManager = FileManager.default
        //copy image to created file path in document.
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        // create the destination file url to save your image
        let fileURL = documentsDirectory!.appendingPathComponent("MM/images/cards_data.zip")
        let folderURL = documentsDirectory!.appendingPathComponent("MM/images/upload")
        // get your UIImage jpeg data representation and check if the destination file url already exists
        
        if  FileManager.default.fileExists(atPath: fileURL.path) {
            //if already image
            //delete data.
            
            do {
                try fileManager.removeItem(atPath: fileURL.path)
                if  !FileManager.default.fileExists(atPath: fileURL.path) {
                    print("file deleted")
                }
            } catch {
                print("error delete file:", error)
            }
        }
        
        if  FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try fileManager.removeItem(atPath: folderURL.path)
                if  !FileManager.default.fileExists(atPath: folderURL.path) {
                    print("path deleted")
                }
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
        
    }
    
    
    
    //create order data.
    func creatOrderDataAndSave(){
        
        let data = "주문번호 : \(orderNumber)\n성명 : \(UserDefaults.standard.string(forKey: "name")!)\n연락처 : \(UserDefaults.standard.string(forKey: "phone")!)\n주소 : \(UserDefaults.standard.string(forKey: "address")!)"
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        // create the destination file url to save your image
        let fileURL = documentsDirectory!.appendingPathComponent("MM/images/upload/data.txt")
       
        do {
            try data.write(to: fileURL, atomically: false, encoding: .utf8)
            print("data.txt saved")
        }
        catch {
            print("error")
            
        }
        
    }
    
    
    
    
    func createCoverAndSave(){
        
        if UserDefaults.standard.string(forKey: "coverPath") != nil{
            
            let cardRect = CGRect(x: 0, y: 0, width: 1600, height: 2400)
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 1600, height: 2400), false, 0)
            UIColor.white.setFill()
            UIRectFill(cardRect)
            
            //get Image.
            let copyDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let copyPath = UserDefaults.standard.string(forKey: "coverPath")
            let fileURL = copyDocumentsDirectory.appendingPathComponent(copyPath!)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                
                
                //set blur
                ///set image using kongfisher.
                let provider = LocalFileImageDataProvider(fileURL: fileURL)
                
                let processor = OverlayImageProcessor(overlay: .black, fraction: 0.7) >> BlurImageProcessor(blurRadius: 15.0)
                let tempImageView = UIImageView()
                tempImageView.kf.setImage(with: provider, options: [.processor(processor)])
                
               
                
                
                let processedImage = tempImageView.image
                
                //draw image.
                processedImage!.draw(in: CGRect(x: 0, y: 0, width: 1600, height: 2400))
                
                
                //draw title.
                let title = "FRAME"
                
                let titleAttributes: [NSAttributedString.Key : Any] = [
                    .paragraphStyle: NSMutableParagraphStyle(),
                    .font: UIFont.init(name: "Quicksand-Light", size: 144)!,
                    .foregroundColor: UIColor(rgb: 0xFFFFFF)
                ]
                
                let titleAttributedString = NSAttributedString(string: title, attributes: titleAttributes)
                titleAttributedString.draw(at: CGPoint(x: 575.5, y: 1006))
                
                //draw sub.
                let sub = "your life in frame"
                
                let subAttributes: [NSAttributedString.Key : Any] = [
                    .paragraphStyle: NSMutableParagraphStyle(),
                    .font: UIFont.init(name: "Quicksand-Light", size: 28)!,
                    .foregroundColor: UIColor(rgb: 0xFFFFFF)
                ]
                
                let subAttributedString = NSAttributedString(string: sub, attributes: subAttributes)
                subAttributedString.draw(at: CGPoint(x: 690, y: 1186.5))
                
                
            }else{
                print("No Image")
            }
            
            let createdCover: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            
            //save Image to upload folder.
            
            //check file path.
            let fileManager = FileManager.default
            if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let frameFilePath = "MM/images/upload"
                let filePath =  tDocumentDirectory.appendingPathComponent("\(frameFilePath)")
                if !fileManager.fileExists(atPath: filePath.path) {
                    do {
                        try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                        NSLog("Create file path succeed")
                    } catch {
                        NSLog("Couldn't create document directory")
                        return
                    }
                }
                //NSLog("Document directory is \(filePath)")
            }
            
            //copy image to created file path in document.
            // get the documents directory url
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            // choose a name for your image
            let fileName = "MM/images/upload/cover_upload.jpg"
            // create the destination file url to save your image
            let savefileURL = documentsDirectory!.appendingPathComponent(fileName)
            
            
            //save image.
            do {
                let copyData = createdCover.jpegData(compressionQuality: 0.8)
                
                // writes the image data to disk
                try copyData!.write(to: savefileURL)
                //NSLog("saved file path : \(savefileURL.path)")
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
            
        }else{
            //white cover
            let cardRect = CGRect(x: 0, y: 0, width: 1600, height: 2400)
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 1600, height: 2400), false, 1)
            UIColor.white.setFill()
            UIRectFill(cardRect)
            
            //draw title.
            let title = "FRAME"
            
            let titleAttributes: [NSAttributedString.Key : Any] = [
                .paragraphStyle: NSMutableParagraphStyle(),
                .font: UIFont.init(name: "Quicksand-Light", size: 144)!,
                .foregroundColor: UIColor(rgb: 0x000000)
            ]
            
            let titleAttributedString = NSAttributedString(string: title, attributes: titleAttributes)
            titleAttributedString.draw(at: CGPoint(x: 575.5, y: 1006))
            
            //draw sub.
            let sub = "your life in frame"
            
            let subAttributes: [NSAttributedString.Key : Any] = [
                .paragraphStyle: NSMutableParagraphStyle(),
                .font: UIFont.init(name: "Quicksand-Light", size: 28)!,
                .foregroundColor: UIColor(rgb: 0x000000)
            ]
            
            let subAttributedString = NSAttributedString(string: sub, attributes: subAttributes)
            subAttributedString.draw(at: CGPoint(x: 690, y: 1186.5))
            
            let createdCover: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            
            //save Image to upload folder.
            
            //check file path.
            let fileManager = FileManager.default
            if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let frameFilePath = "MM/images/upload"
                let filePath =  tDocumentDirectory.appendingPathComponent("\(frameFilePath)")
                if !fileManager.fileExists(atPath: filePath.path) {
                    do {
                        try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                        NSLog("Create file path succeed")
                    } catch {
                        NSLog("Couldn't create document directory")
                        return
                    }
                }
                //NSLog("Document directory is \(filePath)")
            }
            
            //copy image to created file path in document.
            // get the documents directory url
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            // choose a name for your image
            let fileName = "MM/images/upload/cover_upload.jpg"
            // create the destination file url to save your image
            let savefileURL = documentsDirectory!.appendingPathComponent(fileName)
            
            
            //save image.
            do {
                let copyData = createdCover.jpegData(compressionQuality: 0.8)
                
                // writes the image data to disk
                try copyData!.write(to: savefileURL)
                //NSLog("saved file path : \(savefileURL.path)")
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
            
            
        }
    }
    
    
    
    
    
    func createImageAndSave(cardItem: cardItem, count: Int){
        
        
        let cardRect = CGRect(x: 0, y: 0, width: 1600, height: 2400)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1600, height: 2400), false, 1)
        UIColor.white.setFill()
        UIRectFill(cardRect)
        
        //get Image.
        let copyDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let copyPath = copyDocumentsDirectory.appendingPathComponent(cardItem.image!)
        if FileManager.default.fileExists(atPath: copyPath.path) {
            
            
            //draw image.
            let cardItemImage = UIImage(contentsOfFile: copyPath.path)
            cardItemImage?.draw(in: CGRect(x: 51.38, y: 51.38, width: 1488, height: 2080))
            
            
            //draw title.
            let title = cardItem.title
            
            let titleAttributes: [NSAttributedString.Key : Any] = [
                .paragraphStyle: NSMutableParagraphStyle(),
                .font: UIFont.init(name: "NanumSquareOTFB", size: 72)!,
                .foregroundColor: UIColor(rgb: 0x565555)
            ]
            
            let titleAttributedString = NSAttributedString(string: title!, attributes: titleAttributes)
            titleAttributedString.draw(at: CGPoint(x: 54.4, y: 2156.68))
            
            //draw bar.
            let rectangle = CGRect(x: 54.4, y: 2292.02, width: 185.412, height: 0.5)
            UIColor.darkGray.setFill()
            UIRectFill(rectangle)
            
            //draw date.
            let date = cardItem.regdate
            
            let dateAttributes: [NSAttributedString.Key : Any] = [
                .paragraphStyle: NSMutableParagraphStyle(),
                .font: UIFont.init(name: "NanumSquareOTFB", size: 40)!,
                .foregroundColor: UIColor(rgb: 0x565555)
            ]
            
            let dateAttributedString = NSAttributedString(string: date!, attributes: dateAttributes)
            dateAttributedString.draw(at: CGPoint(x: 54.4, y: 2306.899))
            
            //draw content.
            let content = cardItem.content! as NSString
            
            
            let paragraphStyle = NSMutableParagraphStyle()
            //paragraphStyle.alignment =
            //paragraphStyle.firstLineHeadIndent = 5.0
            
            let contentAttributes: [NSAttributedString.Key : Any] = [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.init(name: "NanumSquareOTFB", size: 40)!,
                .foregroundColor: UIColor(rgb: 0x38322F)
            ]
            
            let startX: CGFloat = 1545.6
            var startY: CGFloat = 2157.68
            
            var currentLine = 1
            
            for line:String in content.components(separatedBy: "\n"){
                
                if currentLine <= 4 {
                    let contentAttributedString = NSAttributedString(string: line, attributes: contentAttributes)
                    let calculatedX = startX - contentAttributedString.size().width
                    contentAttributedString.draw(at: CGPoint(x: calculatedX, y: startY))
                    startY += contentAttributedString.size().height
                    currentLine += 1
                }
                
            }
            
            
            
        }else{
            print("No Image \(cardItem.image!)")
        }
        
        let createdImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        //save Image to upload folder.
        
        //check file path.
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let frameFilePath = "MM/images/upload"
            let filePath =  tDocumentDirectory.appendingPathComponent("\(frameFilePath)")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    NSLog("Create file path succeed")
                } catch {
                    NSLog("Couldn't create document directory")
                    return
                }
            }
            //NSLog("Document directory is \(filePath)")
        }
        
        //copy image to created file path in document.
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        // choose a name for your image
        let fileName = "MM/images/upload/\(cardItem.cardId!)_\(count)_upload.jpg"
        // create the destination file url to save your image
        let savefileURL = documentsDirectory!.appendingPathComponent(fileName)
        
        
        //save image.
        do {
            let copyData = createdImage.jpegData(compressionQuality: 0.8)
            
            // writes the image data to disk
            try copyData!.write(to: savefileURL)
            //NSLog("saved file path : \(savefileURL.path)")
            print("file saved")
        } catch {
            print("error saving file:", error)
        }
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func unwindFromPay(segue:UIStoryboardSegue) {
        
        
        
    }
    
    
    
}


extension
BuyViewController: SelectCellDelegate{
    
    //index : 현재 아이템 인덱스, currentCoumt : 버튼 눌렀을때 변화된 선택카드수(화면에 표시된 수와 같음)
    // count -
    func subBtnPressed(index: Int, currentCount: Int) {
        print("index:\(cardList[index].title!) , currentCount:\(currentCount)")
        
        orderList[index] = currentCount
        print(orderList)
    }
    
    
    // count +
    func addBtnPressed(index: Int, currentCount: Int) {
        print("index:\(cardList[index].title!) , currentCount:\(currentCount)")
        
        orderList[index] = currentCount
        print(orderList)
        
    }
    
    
}
