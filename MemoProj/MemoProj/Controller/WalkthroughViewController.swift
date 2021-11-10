//
//  WalkthroughViewController.swift
//  MemoProj
//
//  Created by 이경후 on 2021/11/10.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var introVIew: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var introLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introVIew.layer.cornerRadius = 20
        okButton.layer.cornerRadius = 15
        
        introLabel.font = .boldSystemFont(ofSize: 20)
        introLabel.numberOfLines = 0
        introLabel.text = "처음 오셨군요!\n환영합니다: )\n\n당신만의 메모를 작성하고 관리해보세요!"
        //opacity
        mainView.backgroundColor = UIColor.white.withAlphaComponent(0.7)

    }
    @IBAction func okButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
    }
    
}
