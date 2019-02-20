//
//  ViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 07/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class FirstViewController: UIViewController {
    
    
    var uiAlertControl: UIAlertController?
    
    @IBOutlet weak var mainCoverImageView: UIImageView!
    
    //change for color.
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var ToSettingBtn: UIButton!
    @IBOutlet weak var logoMain: UILabel!
    @IBOutlet weak var logoSub: UILabel!
    
    
    var style: UIStatusBarStyle = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //set help view when first start.
        //값이 없거나 처음일때.
        if UserDefaults.standard.bool(forKey: "notFirst") == false {
            //처음일때.
            let viewController = self.instanceHelpViewController(name: "masterViewController")
            
            //start help page.
            self.present(viewController!, animated: false)
        }
        
        
        
        
        //show notice if noticeAlarm ON
        
        let noticeFlag = UserDefaults.standard.string(forKey: "noticeAlarm")
        
        if noticeFlag == "ON" {
            
            //request
            AF.request("http://lccandol.cafe24.com/notice.php").response { response in // method defaults to `.get`
                debugPrint(response)
                
                
                if let data = response.data, let imageUrl = String(data: data, encoding: .utf8) {
                    
                    //imageUrl -> 서버에 등록된 주소.
                    
                    
                    //use retrieveImage for cache
                    KingfisherManager.shared.retrieveImage(with: URL(string: imageUrl)!) { result in
                        switch result {
                        case .success(let value):
                            //print(value.image)
                            
                            self.uiAlertControl = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                            
                            let height:NSLayoutConstraint = NSLayoutConstraint(item: self.uiAlertControl!.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width)
                            self.uiAlertControl!.view.addConstraint(height);
                            
                            let image = UIImageView(image: value.image)
                            self.uiAlertControl!.view.addSubview(image)
                            
                            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
                            image.isUserInteractionEnabled = true
                            image.addGestureRecognizer(singleTap)
                            
                            image.translatesAutoresizingMaskIntoConstraints = false
                            self.uiAlertControl!.view.addConstraint(NSLayoutConstraint(item: image, attribute: .centerX, relatedBy: .equal, toItem: self.uiAlertControl!.view, attribute: .centerX, multiplier: 1, constant: 0))
                            self.uiAlertControl!.view.addConstraint(NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: self.uiAlertControl!.view, attribute: .centerY, multiplier: 1, constant: 0))
                            self.uiAlertControl!.view.addConstraint(NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant:UIScreen.main.bounds.width - 50 ))
                            self.uiAlertControl!.view.addConstraint(NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.width - 50))
                            
                            
                            
                            self.present(self.uiAlertControl!, animated: true, completion: nil)
                            
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                    /** image downloader
                     let downloader = ImageDownloader.default
                     downloader.downloadImage(with: URL(string: imageUrl)!) { result in
                     
                     }
                     */
                    
                }
            }
        }
        
        
        //set main conver..
        let savedCoverPath = UserDefaults.standard.string(forKey: "coverPath") as NSString?
        if  savedCoverPath != nil && (savedCoverPath?.length)! > 0 { //값이 있다면.
            
            print("maincover exists")
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
            let fileName = savedCoverPath
            let fileURL = documentsDirectory!.appendingPathComponent(fileName! as String)
            
            if  FileManager.default.fileExists(atPath: fileURL.path) {
                //if main cover exists.
                
                
                //mainCoverImageView.image = UIImage(contentsOfFile: fileURL.path)
                
                
                ///set image using kongfisher.
                let provider = LocalFileImageDataProvider(fileURL: fileURL)
                
                let processor = OverlayImageProcessor(overlay: .black, fraction: 0.7) >> BlurImageProcessor(blurRadius: 15.0)
                mainCoverImageView.kf.setImage(with: provider, options: [.processor(processor)])
                
                //change color.
                startBtn.setTitleColor(UIColor.white, for: .normal)
                ToSettingBtn.setImage(UIImage(named: "setting_white_normal"), for: .normal)
                logoMain.textColor = UIColor.white
                logoSub.textColor = UIColor.white
                
                
                //set status bar.
                style = .lightContent
                setNeedsStatusBarAppearanceUpdate()
                
                
            }
        }else{
            
            //reset View.
            mainCoverImageView.image = nil
            
            startBtn.setTitleColor(UIColor.darkGray, for: .normal)
            ToSettingBtn.setImage(UIImage(named: "setting_white_pressed"), for: .normal)
            logoMain.textColor = UIColor.black
            logoSub.textColor = UIColor.black
            
            //set status bar.
            style = .default
            setNeedsStatusBarAppearanceUpdate()
        }
        
        
        
    }
    
    //set status bar.
    override var preferredStatusBarStyle:UIStatusBarStyle{
        return style
    }
    
    
    
    //alert.
    @objc func tapDetected() {
        print("Imageview Clicked")
        uiAlertControl?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        
        
        
    }
}

