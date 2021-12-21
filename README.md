**Memo App Project 🏃🏻‍♂ (2021.11.9 ~)** : **평가 과제**

1. 기본적인 레이아웃 및 연결  - 11.9 
2. 인트로, Realm - 11.10
3. 오류가 너무 많음 / 서치바 컨트롤러 구현 해야함 - 11.12 [이번주 시간이 부족했습니다😭 피드백은 못받게 되겠지만 개인적으로 여쭤보겠습니다😄]
4. 날짜포맷, 키보드, 공유기능, 백버튼시 메모저장, 두개의 칼럼으로 저장 미반영 - 11.15

<br></br>

<div align = "center">
  
  ![스크린샷 2021-11-15 오후 11 27 44](https://user-images.githubusercontent.com/53691249/141798699-0383b331-481d-4540-8422-b6fb10269de1.png)
  
</div>

### 1.MVC 디자인 패턴
- 어렴풋이 들었던 MVC 디자인 패턴이 기억이나 한 번 적용해보고자 폴더관리를 해보았으나 정확하게 하고 있는지 아직은 모르겠다.

**[ MVC ]**
- Model : Realm table과 MemoviewController에서 사용하는 프로토콜을 저장
- View : Storyboard 및 cell
- Controller : Memo, Walkthrough,Editor / controller의 Extension

**개인프로젝트에서 확실하게 익혀두고 MVVM에 대해서 학습해보자.**
<br></br>
### 2.데이터 전달

```swift
protocol SendDataDelegate {
    //기본
    func textData(title : String,content : String)
    //고정 + 메모
    func textDataTag(title : String,content : String,tagging : Int)
    //서치
    func textDataId(title : String,content : String,id : ObjectId)
    
}
```
- 상당히 애를 먹인 부분이다. 
- 새로운 메모를 생성시에는 가장 상위의 textData를 이용
- 고정되어 있거나 메모에 있을 경우에는 textDataTag를 이용
- 검색시에는 textDataId를 이용했는데 이 경우에는 섹션이 하나이기 때문에 indexPath.section/row를 이용하기 까다로워 id값을 이용해 전달했다.
<br></br>
### 3.NumberFormt
```swift
func numberFormatter(number: Int) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
```
- Date말고 숫자도 Format을 정해줄수 있게 만들어주는 함수
<br></br>
### 4.레이블의 일부를 커스터마이징
```swift
 let attributtedString = NSMutableAttributedString(string: cell.titleLabel.text!)
            attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: (cell.titleLabel.text! as NSString).range(of:"\(searchController.searchBar.text!)"))
            cell.titleLabel.attributedText = attributtedString
```
<br></br>
### 5.LeadingSwipe 함수
```swift
func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {}
```
- 까먹지 말자😂
<br></br>
### 6.애플리케이션 처음 구동시 확인 함수
```swift
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
```    
- UserDefaults를 이용해 키와 Bool 형태로 저장해두고 애플리케이션을 키면 확인한다.
- 다만 Appdelegate를 활용하면 한번만 확인할 수 있다는 글을 본 것 같아 확인해볼 필요가 있다.
<br></br>
### 7.고정된 메모와 메모를 분리하기 위한 프로퍼티
```swift
 //고정된 메모와 메모로 분리하기 위한 프로퍼티
    var classifications : [String] {
        return Set(Works.value(forKeyPath: "classification") as! [String]).sorted()
    }
```
- indexPath.section / indexPath.row를 이용해서 분리되게 보여주는 과정 자체는 쉬웠으나 indexPath.row가 겹치게 되어 고정된 메모의 값 혹은 메모의 값이 혼동되어 표시되거나 오류가 발생했었다.
- Realm에 classification이라는 변수를 추가하고 String 타입으로 '고정된 메모'와 '메모'로 나누고 위의 프로퍼티를 활용하여 테이블 뷰에 보여주었다.
- 상당히 오랜시간 애먹었다.. 아직도 부들부들하다..

<div align="center">
  
  <h4> [중간평] : 처음으로 해보는 간단한 프로젝트 였지만 아직도 구현하지 못한 기능들이 있고 또 오류가 있다. 추후에 개인 프로젝트가 마무리되가거나 시간이 날때마다 수정해야 겠다🏃🏻‍♂️ </h4>

</div> 
<br></br>
<div align="center">
  
  <h4> 기능구현 영상 및 스크린샷</h4>

</div> 
<div align = "center">
  <img src="https://user-images.githubusercontent.com/53691249/141805876-11c52292-c024-45ee-ae45-fdd1fc62cf3d.png" width="30%" height="30%">
<!--  ![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 21 31 25](https://user-images.githubusercontent.com/53691249/141805876-11c52292-c024-45ee-ae45-fdd1fc62cf3d.png){height=300px width=200px} -->
  
</div>
<br></br>
<div align = "center">
  
  ![ezgif com-gif-maker](https://user-images.githubusercontent.com/53691249/141784974-601c45b3-05d0-4d17-90c6-8fde4686fe2a.gif)
  
</div>


