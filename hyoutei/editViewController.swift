//
//  editViewController.swift
//  hyoutei
//
//  Created by user on 2018/09/04.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class editViewController: UIViewController {
    
    var ref:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button2 = UIButton()
        button2.setTitle("戻る", for: .normal)
        button2.frame = CGRect(x: Int(self.view.frame.size.width-100), y: Int(self.view.frame.size.height-90), width: 100, height: 90)
        button2.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.backgroundColor = UIColor.green
        self.view.addSubview(button2)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var textField: UITextField!
    

    @IBAction func addButton(_ sender: Any) {
        
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            
            
            let dictionary:NSDictionary = snapshot.value as! NSDictionary
            var karinumber:String = dictionary["number"]! as! String
            var number = Int(karinumber)
            let StringNumber = (number!+1).description
            self.ref.child("number").setValue(StringNumber)
            self.ref.child("\(StringNumber)").setValue(self.textField.text)
            
            
            
            
        })
            
    
        
    }
    
    
    @objc func goBack(){
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.endEditing(true)
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
