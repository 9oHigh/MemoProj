//
//  EditorViewController.swift
//  MemoProj
//
//  Created by 이경후 on 2021/11/09.
//

import UIKit

class EditorViewController: UIViewController {

    var setText : String = ""
    var delegate : SendDataDelegate?
    var tagging : Int = -1
    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //오른쪽 아이템
        let okBtn = makeBarButtonTitle(title: "완료", style: .plain, target: nil, action: #selector(saveButtonClicked))
        
        let shareBtn = makeBarButtonImage(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: #selector(shareButtonClicked))
        
        navigationItem.rightBarButtonItems = [okBtn,shareBtn]
        memoTextView.text = setText
    }
    
    @objc func saveButtonClicked(){
        if let text = memoTextView.text {
            if tagging == -1 {
                delegate?.textData(title: text, content: text)
            } else {
                delegate?.textDataTag(title: text, content: text, tagging: tagging)
            }
        } 
        self.navigationController?.popViewController(animated: true)
    }
    @objc func shareButtonClicked(){
        
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
