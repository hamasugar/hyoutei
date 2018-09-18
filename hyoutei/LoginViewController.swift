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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let id = UserDefaults.standard.object(forKey: "ID"){
            
            self.textField.text = id as! String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // 会員登録のボタンであります
    @IBAction func button1(_ sender: Any) {
        
        
        if !self.countjudge(){
            return
        }
        //keyにすると親そのものがString型で帰ってくる descriptionでもURLが帰ってくるだけ
        let privateref = Database.database().reference().child("login/\(self.textField.text!)")
        
        privateref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let password = snapshot.value as? String{
                print (snapshot.value as! String)
                print ("sonzaisuru")
                self.makeAlert(message: "このIDはすでに使われています")
            }
            else{

                print ("sonzaisinai")
                
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
                self.makeGoodAlert(message: "会員登録が完了しました")

                
                
            }
            
            
        })
        

    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if !self.countjudge(){
            return
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
        let emailRegEx = "[A-Z0-9a-z]{5,20}"
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
    }

}
