////
////  MemoRealmTable.swift
////  MemoProj
////
////  Created by 이경후 on 2021/11/09.
////

import Foundation
import RealmSwift
import UIKit

class MemoList : Object{
    
    @Persisted var pinChecked : Bool
    
    @Persisted var title : String
    
    @Persisted var content : String
    
    @Persisted var date : Date
    
    @Persisted(primaryKey: true) var _id : ObjectId
    
    convenience init(title : String, content : String) {
        self.init()
        self.title = title
        self.content = content
        self.pinChecked = false
    }
}
