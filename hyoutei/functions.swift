//
//  functions.swift
//  hyoutei
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 hamasugartanaka. All rights reserved.
//

import Foundation
import Firebase


func fetchString(ref: DatabaseReference) -> String {
    
    var returnValue: String!
    
    DispatchQueue.main.async {
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let value = snapshot.value as? String{
                
                returnValue = value
            }
            else {
                returnValue = ""
            }
            
        })
    }
    
   
        return returnValue
    
}


//func fetchString2(ref: DatabaseReference, _ after:@escaping (String) -> String) {
//
//    var returnValue: String!
//
//    DispatchQueue.main.async {
//
//        ref.observeSingleEvent(of: .value, with: {(snapshot) in
//
//            if let value = snapshot.value as? String{
//
//                returnValue = value
//            }
//            else {
//                returnValue = ""
//            }
//
//        })
//        after(returnValue)
//    }
//
//}


func fetchString3(ref: DatabaseReference, completion: @escaping (_ response: String) -> Void) {
    
    DispatchQueue.main.async {
        var returnValue: String!
        
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let value = snapshot.value as? String{
                print ("yes")
                returnValue = value
                completion(returnValue)
            }
            else {
                print ("no")
                returnValue = ""
                completion(returnValue)
            }
            
        })
    }
    
}

//文字列を入れるとハッシュかしたものを返してくれる関数
func hash(original: String) -> String {
    
    let data = original.data(using: .utf8)
    let length = Int(CC_MD5_DIGEST_LENGTH)
    var digest = [UInt8](repeating: 0, count: length)
    _ = data!.withUnsafeBytes { CC_MD5($0, CC_LONG(data!.count), &digest) }
    let hashedString = digest.map { String(format: "%02x", $0) }.joined(separator: "")
    
    return hashedString
}
