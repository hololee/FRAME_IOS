//
//  contentViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 10/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ContentViewController: UIViewController{
    
    
    @IBOutlet weak var helpImageView: UIImageView!
   
    
    var pageIndex: Int!
    var imageFile: String!
    
    override func viewDidLoad() {
        
        
        
        
        switch pageIndex {
        case 1:
  
            helpImageView.loadGif(name: imageFile)
            
        case 2:
  
            helpImageView.loadGif(name: imageFile)
        case 3:

            
            helpImageView.loadGif(name: imageFile)
        case 4:
         
         
            helpImageView.loadGif(name: imageFile)
            
        default:
           
            //set image
            helpImageView.image = UIImage(named: self.imageFile)
        }
        
        
        
        
    }
    
    
}


