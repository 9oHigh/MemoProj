//
//  Extension+MemoViewController.swift
//  MemoProj
//
//  Created by 이경후 on 2021/11/10.
//

import Foundation
import UIKit
import Network

extension MemoViewController :UITableViewDelegate,UITableViewDataSource {
    
    //고정된 메모와 메모의 개수를 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filtered.count
        } else {
            let trueCount = memoRealm.objects(MemoList.self).filter("pinChecked == true").count
            let falseCount =  memoRealm.objects(MemoList.self).filter("pinChecked == false").count
            if trueCount > 0 {
                if section == 0 { return trueCount }
                else { return falseCount }
            } else {
                return falseCount
            }
        }
    }
    //고정된 메모가 있는지 없는지 확인후 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        } else {
            let trueCount = memoRealm.objects(MemoList.self).filter("pinChecked == true").count
            let totalCount = memoRealm.objects(MemoList.self).count
            
            if totalCount > 0 {
                return trueCount > 0 ? 2 : 1
            } else {
                return 0
            }
        }
    }
    
    // 고정된 메모가 있는지 없는지 확인후 반환
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering{
            return "\(numberFormatter(number: filtered.count))개 찾음"
        } else {
            let sectionCount =  numberOfSections(in: memoTableView)
            if sectionCount == 0 {
                return nil
            } else if sectionCount == 1{
                return "메모"
            } else {
                return section == 0 ? "고정된 메모" : "메모"
            }
        }
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
        //UIContextualAction
        let data = self.Works.sorted(byKeyPath: "date").filter("classification == %@", self.classifications[indexPath.section])[indexPath.row]
        
        let pin = UIContextualAction(style: .normal, title: "") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            //고정된 메모의 개수가 5개가 넘을 경우
            if self.memoRealm.objects(MemoList.self).filter("pinChecked == true").count >= 5 && data.pinImage == "pin.fill" {
                self.showAlert(title: "5개 이상의 고정메모를 가질 수 없습니다.", content: "확인")
                self.memoTableView.reloadData()
                return
            }
            
            try! self.memoRealm.write{
                data.pinChecked = !data.pinChecked
                data.classification == "메모" ? (data.classification = "고정된메모") : (data.classification = "메모")
                data.pinImage == "pin.slash.fill" ? (data.pinImage = "pin.fill") : (data.pinImage = "pin.slash.fill")
                self.memoRealm.add(data,update: .modified)
            }
            self.memoTableView.reloadData()
            success(true)
        }
        pin.backgroundColor = .orange
        pin.image = UIImage(systemName: data.pinImage)
        
        return UISwipeActionsConfiguration(actions: [pin])
    }
    //삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            showAlertCheck(title: "메모를 삭제하시겠습니까?", ok: "확인", cancel: "취소") { delete in
                do{
                    try self.memoRealm.write{
                        self.memoRealm.delete(self.Works.sorted(byKeyPath: "date").filter("classification == %@", self.classifications[indexPath.section])[indexPath.row])
                    }
                } catch {
                    self.showAlert(title: "삭제할 수 없는 메모입니다.", content: "확인")
                }
                self.title = "\(self.numberFormatter(number: self.Works.count))개의 메모"
                self.memoTableView.reloadData()
            }
        }
        
    }
    //Realm으로 처리하면서 나머지 다바꾸기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        if isFiltering {
            filtered = filtered.sorted(byKeyPath: "date")
            
            cell.titleLabel.text = filtered[indexPath.row].title
            cell.contentLabel.text = filtered[indexPath.row].content
            
            //라벨 텍스트 색상 변경
            let attributtedString = NSMutableAttributedString(string: cell.titleLabel.text!)
            attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: (cell.titleLabel.text! as NSString).range(of:"\(searchController.searchBar.text!)"))
            cell.titleLabel.attributedText = attributtedString

            let format = DateFormatter()
            format.dateFormat = "yyyy년 MM월 dd일"
            let value = format.string(from: filtered[indexPath.row].date)
            
            cell.dateLabel.text = value
        }else {
            let data = Works.sorted(byKeyPath: "date").filter("classification == %@", classifications[indexPath.section])[indexPath.row]
            
            cell.titleLabel.text = data.title
            cell.contentLabel.text = data.content
            cell.titleLabel.textColor = .black
            //DateFormatter 수정필요! 기간별로 enum 클래스 이용 or 조건
            let format = DateFormatter()
            format.dateFormat = "yyyy년 MM월 dd일"
            let value = format.string(from: data.date)
            
            cell.dateLabel.text = value
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "EditorStoryboard", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "EditorSB") as! EditorViewController
        
        //백버튼
        let backBtn = UIBarButtonItem()
        backBtn.title = "메모"
        backBtn.tintColor = .black
        navigationItem.backBarButtonItem = backBtn
        
        if isFiltering{
            let data = self.filtered[indexPath.row]
            let compData = self.filtered[indexPath.row]._id
            let comp = self.Works.filter("_id == %@",compData)[0]
            vc.delegate = self
            vc.setText = data.content
            vc.id = comp._id
        }
        else {
            let data = self.Works.filter("classification == %@", self.classifications[indexPath.section])[indexPath.row]
            vc.delegate = self
            vc.setText = data.content
            vc.tagging = indexPath.row
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension MemoViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        self.filtered = self.memoRealm.objects(MemoList.self).filter("title CONTAINS '\(text)'")
        
        self.memoTableView.reloadData()
    }
}
extension MemoViewController {
    
    func showAlert(title: String,content : String){
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: content, style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    func showAlertCheck(title: String, ok : String, cancel : String,handler: @escaping (UIAlertAction) -> Void){
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: ok, style: .default,handler: handler)
        let cancel = UIAlertAction(title: cancel, style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    //NumberFormmater : 세자리마다 컴마!
    func numberFormatter(number: Int) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}



