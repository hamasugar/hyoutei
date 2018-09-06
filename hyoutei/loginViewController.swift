//
//  loginViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/30.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var textField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func button1(_ sender: Any) {
        
        let ref = Database.database().reference().child("login")
        
    
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            let dictionary = snapshot.value as! NSDictionary
            
            
            if  dictionary[self.textField.text!] != nil{
                
            
                self.makeAlert(message:"このIDはすでに使われています")
               

            }
            else{
                //会員登録に成功した場合のみ暗号化を実行する
                let data = self.passwordField.text!.data(using: .utf8)!
                let length = Int(CC_MD5_DIGEST_LENGTH)
                var digest = [UInt8](repeating: 0, count: length)
                _ = data.withUnsafeBytes { CC_MD5($0, CC_LONG(data.count), &digest) }
                let crypt = digest.map { String(format: "%02x", $0) }.joined(separator: "")
                
                print (crypt)
                ref.child("\(self.textField.text!)").setValue(crypt)
                
                self.performSegue(withIdentifier: "goSchool", sender: nil)

            }
            
            
        })
        
    }
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        
        let data = self.passwordField.text!.data(using: .utf8)!
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        _ = data.withUnsafeBytes { CC_MD5($0, CC_LONG(data.count), &digest) }
        let crypt = digest.map { String(format: "%02x", $0) }.joined(separator: "")
        
        
        
        let ref = Database.database().reference().child("login")
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            let dictionary = snapshot.value as! NSDictionary
            
            
            
            
            if  let password = dictionary[self.textField.text!]{
                
                if password as! String == crypt{
                    
                    print ("success")
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
    
    
    func makeAlert(message:String){
        
        
        let alert = UIAlertController(title: "認証に失敗しました", message: message, preferredStyle:.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
