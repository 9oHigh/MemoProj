//
//  ViewController.swift
//  MemoProj
//
//  Created by 이경후 on 2021/11/08.
//

import UIKit
import RealmSwift

class MemoViewController: UIViewController,SendDataDelegate {
    //서치바
    let searchController = UISearchController(searchResultsController: nil)
    //첫 로그인 확인
    let userDefaults = UserDefaults.standard
    let memoRealm = try! Realm()
    var Works : Results<MemoList>!
    //검색시 이용할 배열
    var filtered: Results<MemoList>!
    
    //고정된 메모와 메모로 분리하기 위한 배열
    var classifications : [String] {
        return Set(Works.value(forKeyPath: "classification") as! [String]).sorted()
    }
    //현재 서치바가 활성된 상태인지 아닌지 확인하는 프로퍼티 by zedd
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }

    @IBOutlet weak var memoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //기본
        Works = memoRealm.objects(MemoList.self).sorted(byKeyPath: "date")
        filtered = memoRealm.objects(MemoList.self).sorted(byKeyPath: "date")
        print("위치 :",memoRealm.configuration.fileURL!)
        
        //LargeTitle을 이용하기 위해 True
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(numberFormatter(number: Works.count))개의 메모"
        
        //false로 두지 않으면 안보임
        //디폴트가 true인건가
        //이유를 모르겠다.. View안에 있지 않아서 인가?
        self.navigationController?.isToolbarHidden = false
        
        //delegate + dataSource
        memoTableView.delegate = self
        memoTableView.dataSource = self
        
        //searchbar
        //let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController?.searchBar.placeholder = "Search MEMO"
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        //첫로그인 체크
        firstLogInCheck()
    }
    //갱신필수(수정 등등)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "\(numberFormatter(number: Works.count))개의 메모"
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
    //일단 이부분 오류
    func textDataTag(title: String, content: String,tagging: Int) {
        
        let data = self.Works[tagging]
        
        try! memoRealm.write{
            data.content = content
            data.title = title
            memoRealm.add(data,update: .modified)
        }
        self.memoTableView.reloadData()
    }
    func textDataId(title: String, content: String, id: ObjectId) {
        //어차피 하나니까 인덱스는 [0]
        let data = self.Works.filter("_id == %@",id)[0]
        
        try! memoRealm.write{
            data.content = content
            data.title = title
            memoRealm.add(data,update: .modified)
        }
        self.memoTableView.reloadData()
    }
}
