//
//  SendDataProtocol.swift
//  MemoProj
//
//  Created by 이경후 on 2021/11/10.
//

import Foundation

protocol SendDataDelegate {
    func textData(title : String,content : String)
    func textDataTag(title : String,content : String,tagging : Int)
}
