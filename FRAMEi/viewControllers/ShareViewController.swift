//
//  ShareViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 07/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit


extension UIView{
   
    //get UIImage from UIView.
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

class ShareViewController: UIViewController {
    
    
    // data.
    var originalCard: cardItem?
    
    //white background. set for shadow.
    @IBOutlet weak var cardBackBoard: UIView!
    
    //whole share Image.
    @IBOutlet weak var shareView: UIView!
    
    
    //data
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set shadow to card background.
        cardBackBoard.layer.shadowColor = UIColor.lightGray.cgColor
        cardBackBoard.layer.shadowOffset = CGSize.init(width: 2.3, height: 2.3)
        cardBackBoard.layer.shadowOpacity = 0.5
        cardBackBoard.layer.shadowRadius = 3.8
        cardBackBoard.clipsToBounds = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Set Data to card.
        
        //set title
        titleLabel.text = originalCard?.title
        
        //set date
        dateLabel.text = originalCard?.regdate
        
        //set content
        contentLabel.text = originalCard?.content
        
        
        //set image
        let copyDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let copyPath = copyDocumentsDirectory.appendingPathComponent(originalCard!.image!)
        if FileManager.default.fileExists(atPath: copyPath.path) {
            
            let image = UIImage(contentsOfFile: copyPath.path)
            imageView.image = image
            
        }else{
            print("No Image \(originalCard!.image!)")
        }
        
    }
    
    
    
    @IBAction func shareImage(_ sender: UIButton) {
        
        //get image data.
        let shareImage: UIImage = shareView.asImage()
        
        let imageToShare = [shareImage]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        present(activityViewController, animated: true, completion: nil)
    }
 
    
}


