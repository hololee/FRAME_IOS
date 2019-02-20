//
//  ShowCardViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 07/10/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit
import Kingfisher
import Toast_Swift


class ShowCardViewController: UIViewController, UITextViewDelegate {
    
    //all card list.
    var allCardList = [cardItem]()
    
    
    // data.
    var originalCard: cardItem?
    
    //list index.
    var index: Int?
    
    //total counts.
    var total: Int?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleViewLabel: UILabel!
    @IBOutlet weak var dateViewLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var indexViewLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet var thisView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.delegate = self
        
        
        //set shadow.
        backView.layer.shadowColor = UIColor.lightGray.cgColor
        backView.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        backView.layer.shadowOpacity = 0.88
        backView.layer.shadowRadius = 3.0
        backView.clipsToBounds = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //set title
        titleViewLabel.text = originalCard?.title
        
        //set date
        dateViewLabel.text = originalCard?.regdate
        
        //set content
        contentTextView.text = originalCard?.content
        
        //set index
        indexViewLabel.text = "\(index! + 1) / \(total!)"
        
        
        //set image to card
        let copyDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let copyPath = copyDocumentsDirectory.appendingPathComponent(originalCard!.image!)
        if FileManager.default.fileExists(atPath: copyPath.path) {
            
            let image = UIImage(contentsOfFile: copyPath.path)
            imageView.image = image
            
        }else{
            print("No Image \(originalCard!.image!)")
        }
        
        
    }
    
    
    
    //view swiped. right
    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
        
        // to left.
        
        if index! > 0 { // can't move under zero.
            
            //hide smooth.
            UIView.animate(withDuration: 0.5, animations: {
                self.thisView.backgroundColor = UIColor.init(rgb: 0xdddddd)
                self.imageView.alpha = 0.4
                self.titleViewLabel.alpha = 0.0
                self.dateViewLabel.alpha = 0.0
                self.contentTextView.alpha = 0.0
            }, completion: nil)
            
            reLoadData(selectedindex: index! -  1)
            
            //show smooth.
            UIView.animate(withDuration: 0.5, animations: {
                self.thisView.backgroundColor = .white
                self.imageView.alpha = 1.0
                self.titleViewLabel.alpha = 1.0
                self.dateViewLabel.alpha = 1.0
                self.contentTextView.alpha = 1.0
            }, completion: nil)
            
        }else{
            self.view.makeToast("첫 페이지 입니다.")
        }
        
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        
        // to right
        
        if index! + 1 < total!{ // index(current page -> index + 1) must lower than total counts.
            
            //hide smooth.
            UIView.animate(withDuration: 0.5, animations: {
                self.thisView.backgroundColor = UIColor.init(rgb: 0xdddddd)
                self.imageView.alpha = 0.4
                self.titleViewLabel.alpha = 0.0
                self.dateViewLabel.alpha = 0.0
                self.contentTextView.alpha = 0.0
            }, completion: nil)
            
            reLoadData(selectedindex: index! +  1)
            
            //show smooth.
            UIView.animate(withDuration: 0.5, animations: {
                self.thisView.backgroundColor = .white
                self.imageView.alpha = 1.0
                self.titleViewLabel.alpha = 1.0
                self.dateViewLabel.alpha = 1.0
                self.contentTextView.alpha = 1.0
            }, completion: nil)
        }else{
            self.view.makeToast("마지막 페이지 입니다.")
        }
        
    }
    
    //share button pressed.
    @IBAction func sharePressed(_ sender: UIButton) {
        
        //send original card data.
        let shareViewController = self.storyboard?.instantiateViewController(withIdentifier: "share") as! ShareViewController
        shareViewController.originalCard = originalCard
        present(shareViewController, animated: true, completion: nil)
        
    }
    
    
    
    
    func reLoadData(selectedindex: Int){
        
        //set original card.
        originalCard = allCardList[selectedindex]
        //set index.
        index = selectedindex
        
        
        //set data.
        
        //set title
        titleViewLabel.text = originalCard?.title
        
        //set date
        dateViewLabel.text = originalCard?.regdate
        
        //set content
        contentTextView.text = originalCard?.content
        
        //set index
        indexViewLabel.text = "\(selectedindex + 1) / \(total!)"
        
        
        //set image to card
        let copyDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let copyPath = copyDocumentsDirectory.appendingPathComponent(originalCard!.image!)
        if FileManager.default.fileExists(atPath: copyPath.path) {
            
            
            let provider = LocalFileImageDataProvider(fileURL: copyPath)
            imageView.kf.setImage(with: provider)
            
        }else{
            print("No Image \(originalCard!.image!)")
        }
        
    }
    
    
    
    
    // back from shareView.
    @IBAction func unwindToshow(segue:UIStoryboardSegue) {
        
    }
    
}


