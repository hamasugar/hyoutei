//
//  functions.swift
//  hyoutei
//
//  Created by user on 2019/02/05.
//  Copyright © 2019年 hamasugartanaka. All rights reserved.
//

import Foundation
import Firebase
import StoreKit

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



func fetchString(ref: DatabaseReference, completion: @escaping (_ response: String) -> Void) {
    
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

func fetchArray(ref: DatabaseReference, completion: @escaping (_ response: Array<String>) -> Void) {
    
    DispatchQueue.main.async {
        var returnValue = [String]()
        
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let value = snapshot.value as! NSDictionary?{
                print ("yes")
                for (key,_) in value {
                    returnValue.append(key as! String)
                }
                
                completion(returnValue)
            }
            else {
                print ("no")
                returnValue = ["エラーです"]
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

func requestReview() {
    if (UserDefaults.standard.object(forKey: "start") as? Int)! == 10, #available(iOS 10.3, *) {
        SKStoreReviewController.requestReview()//ios10.3以降でないと正しく動作しない
    }
}
