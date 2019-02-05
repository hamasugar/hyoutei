//
//  loginViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/30.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

//これが一応のホーム画面　パスワードは当然ながら暗号化してサーバーに送信する
class LoginViewController: UIViewController {
    
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    
    let idtextField = UITextField()
    let passwordField = UITextField()
    
    let idLabel = UILabel()
    let passwordLabel = UILabel()
    
    let userCreateButton = UIButton()//新規登録のボタン
    let loginButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UserDefaults.standard.set(nil, forKey: "ID")
    }
    
    override func viewDidLayoutSubviews() {
        self.view.backgroundColor = MakeView.backgroundColor
        
        // ラベル
        self.idLabel.frame = CGRect(x: self.width/10, y: self.height/2-100, width: self.width*3/10, height: 40)
        self.passwordLabel.frame = CGRect(x: self.width/10, y: self.height/2, width: self.width*3/10, height: 40)
        self.idLabel.text = text.identifier.rawValue
        self.passwordLabel.text = text.password.rawValue
        self.idLabel.textColor = MakeView.textColor
        self.passwordLabel.textColor = MakeView.textColor
        self.view.addSubview(idLabel)
        self.view.addSubview(passwordLabel)
        
        
        //2つのテキストフィールド
        self.idtextField.frame = CGRect(x: self.width*4/10, y: self.height/2-100, width: self.width*5/10, height:  40)
        self.passwordField.frame = CGRect(x: self.width*4/10, y: self.height/2, width: self.width*5/10, height: 40)
        self.passwordField.isSecureTextEntry = true
        self.idtextField.borderStyle = UITextBorderStyle.roundedRect
        self.passwordField.borderStyle = UITextBorderStyle.roundedRect
        self.idtextField.backgroundColor = MakeView.textFieldColor
        self.passwordField.backgroundColor = MakeView.textFieldColor
        self.view.addSubview(idtextField)
        self.view.addSubview(passwordField)
        
        //2つのボタン
        self.userCreateButton.frame = CGRect(x: self.width/10, y: self.height*6/10, width: self.width*8/10, height: self.height/10)
        self.loginButton.frame = CGRect(x: self.width/10, y: self.height*7/10+20, width: self.width*8/10, height: self.height/10)
        self.userCreateButton.setTitle(text.userCreate.rawValue, for: .normal)
        self.loginButton.setTitle(text.login.rawValue, for: .normal)
        self.userCreateButton.setTitleColor(UIColor.black, for: .normal)
        self.loginButton.setTitleColor(UIColor.black, for: .normal)
        self.userCreateButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        self.userCreateButton.backgroundColor = MakeView.underButtonColor
        self.loginButton.backgroundColor = MakeView.underButtonColor
        self.userCreateButton.layer.masksToBounds = true
        self.loginButton.layer.masksToBounds = true
        self.userCreateButton.layer.cornerRadius = MakeView.cornerRadius
        self.loginButton.layer.cornerRadius = MakeView.cornerRadius
        self.view.addSubview(loginButton)
        self.view.addSubview(userCreateButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let id = UserDefaults.standard.object(forKey: "ID") {
            //Viewdidloadでは遷移をしない
            performSegue(withIdentifier: "goSchool", sender: nil)
        }
    }

    
    // 会員登録のボタン　冗長
    @objc func create(){
        MakeView.puyopuyo(sender:userCreateButton)
        
        if !self.countjudge(){
            return //文字数制限を満たしていなかったらその時点で処理を終える
        }
        let privateref = Database.database().reference().child("login/\(self.idtextField.text!)")
        
        let password: String = fetchString(ref: privateref)
        
        if password != "" {
            self.makeBadAlert(message: text.doubleUser.rawValue)
        }
        else {
            let loginref = Database.database().reference().child("login")
            let hashedString = hyoutei.hash(original: self.passwordField.text!)
            loginref.child("\(self.idtextField.text!)").setValue(hashedString)
            UserDefaults.standard.set(self.idtextField.text!, forKey: "ID")
            self.performSegue(withIdentifier: "goSchool", sender: nil)
        }
    }
    
    @objc func login(){
        MakeView.puyopuyo(sender:loginButton)
        if !self.countjudge(){
            return //文字数制限を満たしていなかったらその時点で処理を終える
        }
        
        let privateref = Database.database().reference().child("login/\(self.idtextField.text!)")
        
        let correctPassword: String = fetchString(ref: privateref)
        
        if correctPassword == "" {
            self.makeBadAlert(message: text.noUser.rawValue)
            return
        }
        
        let hashedString = hyoutei.hash(original: self.passwordField.text!)
            
        if hashedString == correctPassword {
            UserDefaults.standard.set(self.idtextField.text!, forKey: "ID")
            self.performSegue(withIdentifier: "goSchool", sender: nil)
        }
        else {
            self.makeBadAlert(message: text.difPassword.rawValue)
        }
    
    }
    

    func makeBadAlert(message: String) {
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
        
        let idText = self.idtextField.text
        let emailRegEx = "[A-Z0-9a-z]{5,20}" //英数字５文字以上2０文字以内の制限
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let resultid = emailTest.evaluate(with: idText)
        
        let passwordText = self.passwordField.text
        let passwordRegEx = "[A-Z0-9a-z]{5,20}" //英数字５文字以上2０文字以内の制限
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let resultpass = passwordTest.evaluate(with: passwordText)
        
        if resultid == false || resultpass == false{
            self.makeBadAlert(message: text.countJadge.rawValue)
            return false
        }
        else{
            return true
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.idtextField.endEditing(true)
        self.passwordField.endEditing(true)
    }
    

}
