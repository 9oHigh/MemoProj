//
//  ViewController.swift
//  MemoProj
//
//  Created by 이경후 on 2021/11/08.
//

import UIKit
import RealmSwift

class MemoViewController: UIViewController,SendDataDelegate {
    
    let userDefaults = UserDefaults.standard
    let memoRealm = try! Realm()
    let pinRealm = try! Realm()
    var Works : Results<MemoList>!
    
    
    @IBOutlet weak var memoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //기본
        Works = memoRealm.objects(MemoList.self)
        print("위치 :",memoRealm.configuration.fileURL!)
        
        //LargeTitle을 이용하기 위해 True
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(Works.count)개의 메모"
        
        //false로 두지 않으면 안보임
        //디폴트가 true인건가
        //이유를 모르겠다.. View안에 있지 않아서 인가?
        self.navigationController?.isToolbarHidden = false
        
        //delegate + dataSource
        memoTableView.delegate = self
        memoTableView.dataSource = self
        
        firstLogInCheck()
    }
    //갱신필수(수정 등등)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "\(Works.count)개의 메모"
        memoTableView.reloadData()
    }
    //처음인지 아닌지 확인
    func firstLogInCheck(){
        //두번이상 실행
        if userDefaults.bool(forKey: "FirstLogIn") { return }
        //처음 실행
        userDefaults.set(true,forKey: "FirstLogIn")
        
        //처음이므로 튜토리얼 안내
        let storyboard = UIStoryboard(name: "walkthrough", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "walkthrough") as! WalkthroughViewController
        //overFullScreen이여야 라이프사이클 안겹친다!
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addMemoButtonClicked(_ sender: UIBarButtonItem) {
        
        //1.스토리보드 특정
        let storyboard = UIStoryboard(name: "EditorStoryboard", bundle: nil)

        //2.스토리보드 내 많은 뷰컨트롤러 중 전환하고자 하는 뷰컨트롤러 가져오기
        let vc = storyboard.instantiateViewController(withIdentifier: "EditorSB") as! EditorViewController
        //백버튼
        let backBtn = UIBarButtonItem()
        backBtn.title = "메모"
        backBtn.tintColor = .black
        navigationItem.backBarButtonItem = backBtn
        
        vc.delegate = self
        
        //3.Push (Show)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func textData(title : String,content: String) {
        let newData = MemoList(title: title, content: content)
        
        try! memoRealm.write{
            memoRealm.add(newData)
        }
        self.memoTableView.reloadData()
    }
    func textDataTag(title: String, content: String,tagging: Int) {
        let data = self.Works[tagging]
        
        try! memoRealm.write{
            data.content = content
            data.title = title
            memoRealm.add(data,update: .modified)
        }
        self.memoTableView.reloadData()
    }
}
