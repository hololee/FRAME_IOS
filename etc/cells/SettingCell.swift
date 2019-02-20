//
//  SettingCell
//  FRAMEi
//
//  Created by JongHyeok on 08/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit

protocol SettingCell1Delegate {
    func openHelp()
}

class SettingCell: UITableViewCell{
    
      var delegate: SettingCell1Delegate?
    
    var index: Int?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingBtn: UIButton!
    
    
    @IBAction func settingBtnPres(_ sender: UIButton) {
        
        
        switch  index {
        case 0:
            if let url = URL(string: "https://m.cafe.naver.com/ArticleList.nhn?search.clubid=29609940&search.menuid=17&search.boardtype=L"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 1:
            if let url = URL(string: "http://cafe.naver.com/framelife"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 2:
            //show help.
              delegate?.openHelp()
           
        case 4:
            //set noticeAlarm data.
            if UserDefaults.standard.string(forKey: "noticeAlarm") == "ON"{
                //set off.
                UserDefaults.standard.set("OFF", forKey: "noticeAlarm")
                settingBtn.setTitle("OFF", for: .normal)
            }else {
                //set ON.
                UserDefaults.standard.set("ON", forKey: "noticeAlarm")
                settingBtn.setTitle("ON", for: .normal)
            }
            
            
            
        case 5: // open source.
            if let url = URL(string: "https://m.cafe.naver.com/ArticleRead.nhn?clubid=29609940&articleid=23&page=1&boardtype=L"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 6:// font
            if let url = URL(string: "https://m.cafe.naver.com/ArticleRead.nhn?clubid=29609940&articleid=9&page=1&boardtype=L"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 7:// app
            if let url = URL(string: "https://m.cafe.naver.com/ArticleRead.nhn?clubid=29609940&articleid=23&page=1&boardtype=L"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default:
            print("else")
        }
        
        
    }
    
    
}
