//
//  helpManager.swift
//  FRAMEi
//
//  Created by JongHyeok on 10/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit
import Kingfisher

extension UIViewController {
    var helpStoryBoard: UIStoryboard {
        return UIStoryboard(name: "help", bundle: Bundle.main)
    }
    func instanceHelpViewController(name: String) -> UIViewController? {
        return self.helpStoryBoard.instantiateViewController(withIdentifier: name)
    }
}

//for alert image.
extension UIImage {
    func imageWithSize(_ size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

extension UIAlertAction {
    convenience init(title: String?, style: UIAlertAction.Style, image: UIImage, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        self.actionImage = image
    }
    
    convenience init?(title: String?, style: UIAlertAction.Style, imageNamed imageName: String, handler: ((UIAlertAction) -> Void)? = nil) {
        if let image = UIImage(named: imageName) {
            self.init(title: title, style: style, image: image, handler: handler)
        } else {
            return nil
        }
    }
    
    var actionImage: UIImage {
        get {
            return self.value(forKey: "image") as? UIImage ?? UIImage()
        }
        set(image) {
            self.setValue(image, forKey: "image")
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView{
    
    func hideLoader(removeFrom : UIView){
        removeFrom.subviews.last?.removeFromSuperview()
    }
    
    func customActivityIndicator(view: UIView, widthView: CGFloat?) -> UIView{
        
        //Config UIView
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        var selfWidth = view.frame.width
        if widthView != nil{
            selfWidth = widthView ?? selfWidth
        }
        
        let selfHeigh = view.frame.height
        let loopImages = UIImageView()
        
        
        let imageListArray = [UIImage(named: "ld1")!, UIImage(named: "ld2")!, UIImage(named: "ld3")!, UIImage(named: "ld4")!, UIImage(named: "ld5")!, UIImage(named: "ld6")!]
        // Put your desired array of images in a specific order the way you want to display animation.
        
        loopImages.animationImages = imageListArray
        loopImages.animationDuration = TimeInterval(0.36)
        loopImages.startAnimating()
        
        let imageFrameX = (selfWidth / 2) - 40
        let imageFrameY = (selfHeigh / 2) - 30
        var imageWidth = CGFloat(100)
        var imageHeight = CGFloat(65.266)
        
        if widthView != nil{
            imageWidth = widthView ?? imageWidth
            imageHeight = widthView ?? imageHeight
        }
        
        
        
        
        // Define UIView frame
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height)

        //ImageFrame
        loopImages.frame = CGRect(x: imageFrameX, y: imageFrameY, width: imageWidth, height: imageHeight)

        //add loading and label to customView
        self.addSubview(loopImages)
        return self
    }
    
}
