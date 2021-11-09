//
//  ViewController.swift
//  MemoProj
//
//  Created by 이경후 on 2021/11/08.
//

import UIKit
//import RealmSwift

class MemoViewController: UIViewController {

    @IBOutlet weak var memoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.leftBarButtonItem?.tintColor = .black
//        navigationItem.leftBarButtonItem?.title = "메모"
        
        //LargeTitle을 이용하기 위해 True
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(0)개의 메모"
        
        //false로 두지 않으면 안보임
        //디폴트가 true인건가
        //이유를 모르겠다.. View안에 있지 않아서 인가?
        
        self.navigationController?.isToolbarHidden = false
        
        //delegate + dataSource
        memoTableView.delegate = self
        memoTableView.dataSource = self
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
        
        //3.Push (Show)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MemoViewController :UITableViewDelegate,UITableViewDataSource {
    
    //고정된 메모와 메모의 개수를 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    //고정된 메모가 있는지 없는지 확인후 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    // 고정된 메모가 있는지 없는지 확인후 반환
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "고정된 메모" : "메모"
    }
    //섹션 헤더 커스터마이징
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: 60)
        myLabel.font = UIFont.boldSystemFont(ofSize: 25)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    //헤더에 맞춰 높이 주기
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    //고정시 5개이상이면 알림 + 고정메모에 있는 경우 이미지 변환
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        
        let pin = UIContextualAction(style: .normal, title: "Like") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                success(true)
                print("오케이")
            self.memoTableView.reloadData()
            }
        
        pin.backgroundColor = .orange
        pin.image = UIImage(systemName: "pin.fill")
        //like.image = UIImage(systemName: "pin.slash.fill")
        
        return UISwipeActionsConfiguration(actions: [pin])
    }
    //삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            do{
               print("Delete 오케이")
            } catch {
                print("Delete 실패")
            }
        }

        
        memoTableView.reloadData()
    }
    //Realm으로 처리하면서 나머지 다바꾸기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = "안녕"
        cell.contentLabel.text = "안녕하세요. 감사해요. 잘있어요. 다시만나요. 아침해가뜨면~"
        cell.dateLabel.text = "2020.02.02"
        
        return cell
    }
    
    
    
}



