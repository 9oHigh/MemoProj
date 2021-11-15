//
//  SendDataProtocol.swift
//  MemoProj
//
//  Created by 이경후 on 2021/11/10.
//

import Foundation
import RealmSwift

protocol SendDataDelegate {
    //기본
    func textData(title : String,content : String)
    //고정 + 메모
    func textDataTag(title : String,content : String,tagging : Int)
    //서치
    func textDataId(title : String,content : String,id : ObjectId)
    
}
