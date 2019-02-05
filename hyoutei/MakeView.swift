//
//  MakeView.swift
//  hyoutei
//
//  Created by user on 2018/09/18.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import Foundation
import UIKit

class MakeView{
    
    static let buttonHeight:Int = 60
    static let space:Int = 10
    static var buttonSpace:Int{return buttonHeight+space}
    
    
    static let backgroundColor = UIColor(red: 228.0/256, green: 221.0/256, blue: 201.0/256, alpha: 1.0)
    static let buttonColor = UIColor.white
    static let fontsize = UIFont.systemFont(ofSize: 22.0)
    static let cornerRadius = CGFloat(10.0)
    static let underButtonColor = UIColor(red: 255.0/256, green: 169.0/256, blue: 146.0/256, alpha: 1.0)
    static let underButtonHeight = 50
    
    static let textColor = UIColor.black
    static let textFieldColor = UIColor.white
    //ボタンをプヨプヨさせるメソッド
    static func puyopuyo(sender:UIButton){
        
        UIView.animate(withDuration: 0.1,
                       
            animations: { () -> Void in
                // 拡大用アフィン行列を作成する.
                sender.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                // 縮小用アフィン行列を作成する.
                sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })

    }
    
    
}
