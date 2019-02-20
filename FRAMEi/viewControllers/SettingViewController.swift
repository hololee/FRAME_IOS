//
//  SettingViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 07/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit
import CropViewController

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    
    
    //  뷰가 화면에 출력되면 호출
    override func viewWillAppear(_ animated: Bool) {
        
        // 테이블 데이터 리로드
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        nameText.delegate = self
        phoneText.delegate = self
        addressText.delegate = self
        
        //set data if exists.
        nameText.text = UserDefaults.standard.string(forKey: "name")
        phoneText.text = UserDefaults.standard.string(forKey: "phone")
        addressText.text = UserDefaults.standard.string(forKey: "address")
        
        
        
        
        
    }
    
    
    @IBAction func saveSetting(_ sender: UIButton) {
        
        
        
        //back to main.
        dismiss(animated: false, completion: nil)
        
    }
    
    
    
    //입력이 시작될 때.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //포커스.
        switch  textField {
            
        case nameText:
            print("name")
            nameText.becomeFirstResponder()
            
        case phoneText:
            print("phone")
            phoneText.becomeFirstResponder()
            
        case addressText:
            print("address")
            addressText.becomeFirstResponder()
            
        default:
            print("none")
        }
        
        
    }
    
    //입력 종료시.
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch  textField {
            
        case nameText:
            print("name")
            nameText.resignFirstResponder()
           
            
            //이름 data save.
            //userdefault 이용.
            UserDefaults.standard.set(nameText.text!, forKey: "name")
            
            
        case phoneText:
            print("phone")
          
            
            let phoneTextC: String = phoneText.text!
            
            if isPhone(candidate: phoneTextC) {
                //save phone
                UserDefaults.standard.set(phoneTextC, forKey: "phone")
                phoneText.resignFirstResponder()
                
            }else{
                //show notice.
                let dialog = UIAlertController(title: "저장되지 않았습니다", message: "핸드폰번호를 정확히 입력하세요.\n('-'을 입력해주세요.)", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                self.present(dialog, animated: true, completion: nil)
            }
            
        case addressText:
            print("address")
            addressText.resignFirstResponder()
            
            //save address
            UserDefaults.standard.set(addressText.text!, forKey: "address")
            
        default:
            print("none")
        }
        
    }
    
    
    // 입력후 done 버튼을 눌렀을때.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch  textField {
            
        case nameText:
            print("name")
            nameText.resignFirstResponder()
            phoneText.becomeFirstResponder()
            
            //이름 data save.
            //userdefault 이용.
            UserDefaults.standard.set(nameText.text!, forKey: "name")
            
            
        case phoneText:
            print("phone")
            
            
            let phoneTextC: String = phoneText.text!
            
            if isPhone(candidate: phoneTextC) {
                //save phone
                UserDefaults.standard.set(phoneTextC, forKey: "phone")
                phoneText.resignFirstResponder()
                addressText.becomeFirstResponder()
                
            }else{
                //show notice.
                let dialog = UIAlertController(title: "경고", message: "핸드폰번호를 정확히 입력하세요.\n('-'을 입력해주세요.)", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                self.present(dialog, animated: true, completion: nil)
            }

        case addressText:
            print("address")
            addressText.resignFirstResponder()
            
            //save address
            UserDefaults.standard.set(addressText.text!, forKey: "address")
            
        default:
            print("none")
        }
        
        return true
    }
    
    
    
    
    // MARK: - Table view data source
    // 테이블 뷰의 셀 개수를 결정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    // 개별 행 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "settingCell2", for: indexPath) as! SettingCell2
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell2.selectionStyle = .none
        cell2.index = indexPath.row
        
        switch indexPath.row {
        case 0:
            
            cell.titleLabel.text = "배송확인"
            cell.settingBtn.setTitle("바로가기", for: .normal)
            cell.settingBtn.setTitleColor(UIColor.red, for: .normal)
            return cell
            
        case 1:
            
            cell.titleLabel.text = "공식카페"
            cell.settingBtn.setTitle("바로가기", for: .normal)
            cell.settingBtn.setTitleColor(UIColor.red, for: .normal)
            return cell
            
        case 2:
            
            cell.titleLabel.text = "도움말"
            cell.settingBtn.setTitle("보기", for: .normal)
            cell.delegate = self
            return cell
            
        case 3:
            
            cell2.titleLabel.text = "메인커버"
            cell2.settingBtn1.setTitle("초기화", for: .normal)
            cell2.settingBtn2.setTitle("선택", for: .normal)
            cell2.delegate = self
            
            return cell2
            
        case 4:
            
            cell.titleLabel.text = "공지팝업"
            //set saved alarm data.
            let noticeFlag = UserDefaults.standard.string(forKey: "noticeAlarm")
            if noticeFlag == nil {
                UserDefaults.standard.set("ON", forKey: "noticeAlarm")
                cell.settingBtn.setTitle("ON", for: .normal)
            }else{
                cell.settingBtn.setTitle( UserDefaults.standard.string(forKey: "noticeAlarm"), for: .normal)
            }
            return cell
            
        case 5:
            
            cell.titleLabel.text = "오픈소스 라이센스"
            cell.settingBtn.setTitle("보기", for: .normal)
            return cell
            
        case 6:
            
            cell.titleLabel.text = "폰트 정보"
            cell.settingBtn.setTitle("보기", for: .normal)
            return cell
            
        case 7:
            
            cell.titleLabel.text = "앱 정보"
            cell.settingBtn.setTitle("보기", for: .normal)
            return cell
            
        default :
            print("default")
            return cell
            
        }
        
        
        
        
    }
    
    
}


// cell2 delegate pattern, get button click. like interface in java.
extension SettingViewController: SettingCell1Delegate, SettingCell2Delegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CropViewControllerDelegate {
    
    
    
    // open help.
    func openHelp() {
        let viewController = self.instanceHelpViewController(name: "masterViewController")
        
        //start help page.
        present(viewController!, animated: false)
        
    }
    
    
    //clear cover data.
    func didButton1Pressed() {
        
        
        //확인 알림창 띄우기.
        let dialog = UIAlertController(title: "초기화", message: "메인커버를 초기화 합니다", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "초기화", style: UIAlertAction.Style.destructive){ (action: UIAlertAction) -> Void in
            
            //커버 초기화.
            UserDefaults.standard.set(nil, forKey: "coverPath")
            
            //dlete cover
            //file path if exists
            let fileManager = FileManager.default
            //copy image to created file path in document.
            // get the documents directory url
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
            // create the destination file url to save your image
            let fileURL = documentsDirectory!.appendingPathComponent("MM/images/etc/main_cover.jpg")
            // get your UIImage jpeg data representation and check if the destination file url already exists
            
            if  FileManager.default.fileExists(atPath: fileURL.path) {
                //if already image
                //delete data.
                
                
                do {
                    try fileManager.removeItem(atPath: fileURL.path)
                    print("file deleted")
                } catch {
                    print("error delete file:", error)
                }
            }
            
        }
        
        let action2 = UIAlertAction(title: "취소", style: UIAlertAction.Style.default)
        
        dialog.addAction(action1)
        dialog.addAction(action2)
        
        self.present(dialog, animated: true, completion: nil)
    }
    
    
    
    //set cover.
    func didButton2Pressed() {
        
        
        //open picker.
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        
        let alert = UIAlertController(title: nil, message: "이미지를 가져올 곳을 선택해주세요.", preferredStyle: .actionSheet)
        
        // 카메라
        let camera = UIAlertAction(title: "카메라", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                // 이미지 피커 화면 표시
                self.present(picker, animated: false)
            }
        }
        
        // 저장앨범
        let savedAlbum = UIAlertAction(title: "저장앨범", style: .default) { (_) in
            picker.sourceType = .savedPhotosAlbum
            // 이미지 피커 화면 표시
            self.present(picker, animated: false)
        }
        // 사진 라이브러리
        let photoLibrary = UIAlertAction(title: "사진 라이브러리", style: .default) {(_) in
            picker.sourceType = .photoLibrary
            // 이미지 피커 화면 표시
            self.present(picker, animated: false)
        }
        
        // 취소
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        // 버튼을 컨트롤러에 등록
        alert.addAction(camera)
        alert.addAction(savedAlbum)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        
        // 알림창 실행
        self.present(alert, animated: false)
        
    }
    
    
    // MARK:- UIImagePickerControllerDelegate
    // 이미지 선택을 완료했을 때 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.title = "crop image"
        
        cropViewController.customAspectRatio = CGSize.init(width: 4, height: 6); //Set the initial aspect ratio as a square
        cropViewController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        cropViewController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.doneButtonTitle = "확인"
        cropViewController.cancelButtonTitle = "취소"
        
        // 이미지 피커 컨트롤러를 닫음
        picker.dismiss(animated: false)
        
        //show cropView
        present(cropViewController, animated: true, completion: nil)
        
    }
    
    //이미지 선택시 호출.
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        //get crop image.
        let getCropedImage: UIImage = image
        
        
        //save cover image.
        
        //check file path.
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let frameFilePath = "MM/images/etc"
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
            NSLog("Document directory is \(filePath)")
        }
        
        //copy image to created file path in document.
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        // choose a name for your image
        let fileName = "MM/images/etc/main_cover.jpg"
        // create the destination file url to save your image
        let fileURL = documentsDirectory!.appendingPathComponent(fileName)
        
        
        //save image.
        do {
            let copyData = getCropedImage.jpegData(compressionQuality: 1.0)
            
            // writes the image data to disk
            try copyData!.write(to: fileURL)
            NSLog("saved file path : \(fileURL.path)")
            print("file saved")
        } catch {
            print("error saving file:", error)
        }
        
        
        //save cover data.
        UserDefaults.standard.set(fileName, forKey: "coverPath")
        
        
        
        //dismiss cropview
        cropViewController.dismiss(animated: true, completion: nil)
        
        
        //확인 알림창 띄우기.
        let dialog = UIAlertController(title: "커버설정", message: "커버가 설정되었습니다", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        
        dialog.addAction(action)
        
        self.present(dialog, animated: true, completion: nil)
        
        
    }
    
    
    func isPhone(candidate: String) -> Bool {
        
        let regex = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)
        
    }
    
    
    
}
