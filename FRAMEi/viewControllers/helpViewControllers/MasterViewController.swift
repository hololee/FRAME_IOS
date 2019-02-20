//
//  MasterViewController.swift
//  FRAMEi
//
//  Created by JongHyeok on 10/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UIPageViewControllerDataSource {
    
    
    var pageViewController: UIPageViewController!
    
    var contentImages = ["help1", "add_g", "edit_g", "move_g","share_g"]
    

    override func viewDidLoad() {
        // 페이지 뷰 컨트롤러 객체 생성
        self.pageViewController = self.instanceHelpViewController(name: "pageViewController") as? UIPageViewController
        self.pageViewController.dataSource = self
        
        // 페이지 뷰 컨트롤러의 기본 페이지 지정
        let startContentViewController = self.getContentViewController(atIndex: 0)!
        self.pageViewController.setViewControllers([startContentViewController], direction: .forward, animated: true)
        
        // 페이지 뷰 컨트롤러 출력 영역
        self.pageViewController.view.frame.origin = CGPoint(x: 0, y: 0)
        self.pageViewController.view.frame.size.width = self.view.frame.width
        self.pageViewController.view.frame.size.height = self.view.frame.height - 90
        
        // 페이지 뷰 컨트롤러를 마스터 뷰 컨트롤러의 자식 뷰 컨트롤러로 지정
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
    }
    
    
    @IBAction func finishHelp(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "notFirst")
        dismiss(animated: true)
        
    }
    
    
    //get contenet controller.
    func getContentViewController(atIndex idx: Int) -> UIViewController? {
        guard self.contentImages.count >= idx && self.contentImages.count > 0 else {
            return nil
        }
        
        // stroyboard ID가 ContentViewController인 뷰 컨트롤러의 인스턴스 생성
        guard let contentView = self.instanceHelpViewController(name: "contentViewController") as? ContentViewController else {
            return nil
        }
        
        contentView.imageFile = self.contentImages[idx]
        contentView.pageIndex = idx
        
        return contentView
    }
    
 
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 현재 페이지 인덱스
        guard var index = (viewController as! ContentViewController).pageIndex else {
            return nil
        }
        // 인덱스가 맨 앞이면 nil
        guard index > 0 else {
            return nil
        }
        
        // 이전 페이지 인덱스
        index -= 1
        return self.getContentViewController(atIndex: index)
    }
    
    // 현재의 콘텐츠 뷰 컨트롤러 뒤쪽에 올 콘텐츠 뷰 컨트롤러 객체
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 현재 페이지 인덱스
        guard var index = (viewController as! ContentViewController).pageIndex else {
            return nil
        }
        
        // 다음 페이지 인덱스
        index += 1
        
        // 인덱스는 배열 데이터의 크기보다 작아야함
        guard index < self.contentImages.count else {
            return nil
        }
        
        return self.getContentViewController(atIndex: index)
    }
    
    
    // 페이지 뷰 컨트롤러가 출력할 페이지의 개수를 알려주는 메서드
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.contentImages.count
    }
    
    // 페이지 뷰 컨트롤러가 최초에 출력할 콘텐츠 뷰의 인덱스를 알려주는 메서드
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
