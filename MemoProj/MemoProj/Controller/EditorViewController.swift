//
//  EditorViewController.swift
//  MemoProj
//
//  Created by 이경후 on 2021/11/09.
//

import UIKit

class EditorViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //오른쪽 아이템
        let okBtn = makeBarButtonTitle(title: "완료", style: .plain, target: nil, action: #selector(check))
        
        let shareBtn = makeBarButtonImage(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: #selector(check))
        
        navigationItem.rightBarButtonItems = [okBtn,shareBtn]
    }
    @objc func check(){
        print("확인했습니다!!")
    }
}
extension EditorViewController{
    func makeBarButtonImage(image: UIImage?, style: UIBarButtonItem.Style,target: Any?, action: Selector? ) -> UIBarButtonItem{
        
        let barButton = UIBarButtonItem(image: image, style: style, target: target, action: action)
        barButton.tintColor = .black
        return barButton
    }
    func makeBarButtonTitle(title: String,style: UIBarButtonItem.Style, target: Any?, action: Selector?)->UIBarButtonItem{
        let barButton = UIBarButtonItem(title: title, style: style, target: target, action: action)
        barButton.tintColor = .black
        return barButton
    }
}
