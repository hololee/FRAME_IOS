//
//  AddViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 07/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit
import CropViewController


class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CropViewControllerDelegate, selectedDateDelegate {
    
    
    var getCropedImage: UIImage?
    var content: String?
    
    var selectedDate : Date? = nil
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateUIButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    //after set date
    func providerSent(_ data: Date) {
        // 외부에서 보내준 데이터를 내가 받아서 갖는다.
        selectedDate = data
        
        //print("get Data")
        
        //set date.
        let getDateFormatter  = DateFormatter()
        getDateFormatter.locale = Locale(identifier: "default")
        getDateFormatter.dateFormat = "yyyy.MM.dd"
        
        
        let getDateString = getDateFormatter.string(from: selectedDate!)
        
        //change date to current date.
        dateUIButton.setTitle(getDateString, for: .normal)
        
        
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "gotoSelect",
            let dest = segue.destination as? DatePickAlertViewController
        {
            dest.selectedDate = selectedDate
            dest.delegate = self  // 내가 서브뷰의 델리게이트가 된다!
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        contentTextView.delegate = self
        titleTextField.delegate = self
        
        //set keyboard layout.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:  UIResponder.keyboardWillHideNotification, object: nil)
        
        //set content init value.
        if(contentTextView.text == ""){
            textViewDidEndEditing(contentTextView)
        }
        
        
        //set content keyboard dismiss gesture recognizer.
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(AddViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapDismiss)
        
        
        //set dfault date.
        let dateFormatter  = DateFormatter()
        dateFormatter.locale = Locale(identifier: "default")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let currentDate = Date()
        let currentDateString = dateFormatter.string(from: currentDate)
        
        //change date to current date.
        dateUIButton.setTitle(currentDateString, for: .normal)
        
        //set shadow.
        backView.layer.shadowColor = UIColor.lightGray.cgColor
        backView.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        backView.layer.shadowOpacity = 0.88
        backView.layer.shadowRadius = 3.0
        backView.clipsToBounds = false
        

        
    }
    
    
    // dismiss keyboard when pressing return key
    @objc func dismissKeyboard(){
        contentTextView.resignFirstResponder()
    }
    
    
    //when edit end
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if (contentTextView.text == "") {
            contentTextView.text = "스토리를 작성해주세요\n(미작성시 공란으로 표시되며\n최대 4줄까지 표시됩니다.)"
            contentTextView.textColor = UIColor.lightGray
        }
        
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        content = textView.text as String
        // print(content!)
    }
    
    //when edit begin
    func textViewDidBeginEditing(_ textView: UITextView){
        
        if (contentTextView.text == "스토리를 작성해주세요\n(미작성시 공란으로 표시되며\n최대 4줄까지 표시됩니다.)"){
            contentTextView.text = ""
            contentTextView.textColor = UIColor.black        }
        
        textView.becomeFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //view up
    @objc func keyboardWillShow(_ sender: NSNotification){
        
        //calculate keyboard height.
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary;
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue;
        let keyboardHeight = keyboardRectangle.size.height;
        
        self.view.frame.origin.y = -keyboardHeight // Move view upward
    }
    
    //view down
    @objc func keyboardWillHide(_ sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    
    //사진 선택.
    @IBAction func pick(_ sender: UIButton) {
        
        // 이미지 피커 인스턴스 생성
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        
        // 알림창 객체 생성
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
        
        cropViewController.customAspectRatio = CGSize.init(width: 1000, height: 1398); //Set the initial aspect ratio as a square
        cropViewController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        cropViewController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.title = "이미지 영역선택"
        cropViewController.doneButtonTitle = "확인"
        cropViewController.cancelButtonTitle = "취소"
        
        // 이미지 피커 컨트롤러를 닫음
        picker.dismiss(animated: false)
        
        //show cropView
        present(cropViewController, animated: true, completion: nil)
        
    }
    
    
    
    //start when image cropped.
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        //get crop image.
        getCropedImage = image
        
        // 선택된 이미지를 미리보기에 표시
        imageView.image = getCropedImage
        
        //dismiss cropview
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // save card.
    @IBAction func svaeCard(_ sender: UIButton) {
        
        
        // 내용을 입력하지 않은경우 경고
        if getCropedImage != nil && self.titleTextField.text?.isEmpty == false{
            
            print("save data")
            
            //create card item.
            let data = cardItem()
            
            
            data.cardId = UInt(Date().timeIntervalSince1970*1000) //device current time to card id.
            data.title = self.titleTextField.text    // 제목
            if self.contentTextView.text == "스토리를 작성해주세요\n(미작성시 공란으로 표시되며\n최대 4줄까지 표시됩니다.)"{
                data.content = ""  // 내용 blank.
            }else{
                 data.content = self.contentTextView.text   // 내용
            }
            data.regdate = dateUIButton.title(for: .normal)  // 시각
            
            
            
            //create file path if not exists.
            let fileManager = FileManager.default
            if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let frameFilePath = "MM/images"
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
            let fileName = "MM/images/\(data.cardId!).jpg"
            // create the destination file url to save your image
            let fileURL = documentsDirectory!.appendingPathComponent(fileName)
            // get your UIImage jpeg data representation and check if the destination file url already exists
            
            if  !FileManager.default.fileExists(atPath: fileURL.path) {
                
                do {
                    let copyData = getCropedImage!.jpegData(compressionQuality: 1.0)
                    
                    // writes the image data to disk
                    try copyData!.write(to: fileURL)
                    NSLog("saved file path : \(fileURL.path)")
                    print("file saved")
                } catch {
                    print("error saving file:", error)
                }
            }
            
            //set image data.
            data.image = fileName  // 이미지 path.
            
            
            
            //save allData
            let databaseManager = DatabaseManager()
            print("get saved db path : \(databaseManager.dbPath!)")
            
            //ready database.
            databaseManager.initDatabase()
            
            //insert card data.
            databaseManager.insertCardData(cardID: String(data.cardId!) as NSString, imagePath: data.image! as NSString, title: data.title! as NSString, date: data.regdate! as NSString, content: data.content! as NSString, location: nil)
            
            //cloase database
            databaseManager.closeDatabase()
   
            // 작성폼 화면을 종료하고 이전 화면으로 돌아감
            dismiss(animated: false, completion: nil)
            
        } else {
            let alert = UIAlertController(title: nil, message: "사진, 제목, 날짜는 필수입력입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    


    
}


