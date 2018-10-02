//
//  loginViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/30.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    
    let textField = UITextField()
    let passwordField = UITextField()
    let idLabel = UILabel()
    let passwordLabel = UILabel()
    let createButton = UIButton()
    let loginButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        self.view.backgroundColor = MakeView.backgroundColor
        
        self.textField.frame = CGRect(x: self.width*4/10, y: self.height/2-100, width: self.width*5/10, height:  40)
        self.passwordField.frame = CGRect(x: self.width*4/10, y: self.height/2, width: self.width*5/10, height: 40)
        self.passwordField.isSecureTextEntry = true
        self.textField.borderStyle = UITextBorderStyle.roundedRect
        self.passwordField.borderStyle = UITextBorderStyle.roundedRect
        self.textField.backgroundColor = UIColor.white
        self.passwordField.backgroundColor = UIColor.white
        self.view.addSubview(textField)
        self.view.addSubview(passwordField)
        
        self.idLabel.frame = CGRect(x: self.width/10, y: self.height/2-100, width: self.width*3/10, height: 40)
        self.passwordLabel.frame = CGRect(x: self.width/10, y: self.height/2, width: self.width*3/10, height: 40)
        
        
        self.idLabel.text = "ID"
        self.passwordLabel.text = "パスワード"
        self.idLabel.textColor = UIColor.black
        self.passwordLabel.textColor = UIColor.black
        self.view.addSubview(idLabel)
        self.view.addSubview(passwordLabel)
        
        
        
        self.createButton.frame = CGRect(x: self.width/10, y: self.height*6/10, width: self.width*8/10, height: self.height/10)
        self.loginButton.frame = CGRect(x: self.width/10, y: self.height*7/10+20, width: self.width*8/10, height: self.height/10)
        self.createButton.setTitle("会員登録", for: .normal)
        self.loginButton.setTitle("ログイン", for: .normal)
        self.createButton.setTitleColor(UIColor.black, for: .normal)
        self.loginButton.setTitleColor(UIColor.black, for: .normal)
        self.createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        self.createButton.backgroundColor = MakeView.underButtonColor
        self.loginButton.backgroundColor = MakeView.underButtonColor
        self.createButton.layer.masksToBounds = true
        self.loginButton.layer.masksToBounds = true
        self.createButton.layer.cornerRadius = MakeView.cornerRadius
        self.loginButton.layer.cornerRadius = MakeView.cornerRadius
        self.view.addSubview(loginButton)
        self.view.addSubview(createButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let id = UserDefaults.standard.object(forKey: "ID"){
            print ("ssss") //こっちはさ動いているので保存はされている模様
            performSegue(withIdentifier: "goSchool", sender: nil) // なぜか遷移しない
            // viewDidLoad内の画面遷移は反応しないのでこっちでやる必要あり
        }

    }

    
    // 会員登録のボタンです
    @objc func create(){
        MakeView.puyopuyo(sender:createButton)
        if !self.countjudge(){
            return //文字数制限を満たしていなかったらその時点で処理を終える
        }
        //keyにすると親そのものがString型で帰ってくる descriptionでもURLが帰ってくるだけ
        let privateref = Database.database().reference().child("login/\(self.textField.text!)")
        
        privateref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let password = snapshot.value as? String{
                self.makeAlert(message: "このIDはすでに使われています")
            }
            else{
                
                let loginref = Database.database().reference().child("login")
                
                //会員登録に成功した場合のみ暗号化を実行する
                let data = self.passwordField.text!.data(using: .utf8)!
                let length = Int(CC_MD5_DIGEST_LENGTH)
                var digest = [UInt8](repeating: 0, count: length)
                _ = data.withUnsafeBytes { CC_MD5($0, CC_LONG(data.count), &digest) }
                let crypt = digest.map { String(format: "%02x", $0) }.joined(separator: "")
                print(crypt)
                loginref.child("\(self.textField.text!)").setValue(crypt)
                
                UserDefaults.standard.set(self.textField.text!, forKey: "ID")
                
                self.performSegue(withIdentifier: "goSchool", sender: nil)
            
                
            }
            
            
        })
    }
    
    @objc func login(){
        MakeView.puyopuyo(sender:loginButton)
        if !self.countjudge(){
            return //文字数制限を満たしていなかったらその時点で処理を終える
        }
        
        
        let privateref = Database.database().reference().child("login/\(self.textField.text!)")
        
        privateref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let password = snapshot.value as? String{
                
                let data = self.passwordField.text!.data(using: .utf8)!
                let length = Int(CC_MD5_DIGEST_LENGTH)
                var digest = [UInt8](repeating: 0, count: length)
                _ = data.withUnsafeBytes { CC_MD5($0, CC_LONG(data.count), &digest) }
                let crypt = digest.map { String(format: "%02x", $0) }.joined(separator: "")
                
                
                if crypt == password{
                    UserDefaults.standard.set(self.textField.text!, forKey: "ID")
                    self.performSegue(withIdentifier: "goSchool", sender: nil)
                    
                }
                else{
                    self.makeAlert(message: "パスワードが違います")
                }
                
                
            }
            else{
                
                self.makeAlert(message: "ユーザーが存在しません")
            }
            
            
        })
        
    }
    

    func makeAlert(message: String) {
        let alert = UIAlertController(title: "認証に失敗しました", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeGoodAlert(message: String) {
        let alert = UIAlertController(title: "認証に成功しました", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func countjudge() -> Bool{
        
        let idText = self.textField.text
        let emailRegEx = "[A-Z0-9a-z]{5,20}" //英数字５文字以上2０文字以内の制限
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result1 = emailTest.evaluate(with: idText)
        
        let passwordText = self.passwordField.text
        let passwordRegEx = "[A-Z0-9a-z]{5,20}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let result2 = emailTest.evaluate(with: passwordText)
        
        if result1 == false || result2 == false{
            self.makeAlert(message: "IDとパスワードは半角英数字５文字以上２０文字以内に設定してください")
            return false
        }
        else{
            return true
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.endEditing(true)
        self.passwordField.endEditing(true)
    }
    

}
