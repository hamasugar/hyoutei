//
//  CommentViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/29.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {
    
    
    var teacher:String!
    
    var  numberOfArray:Int!
    
    var dictionary:NSDictionary!
    
    var teatures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let subjectref = Database.database().reference().child("tokyo/English/\(teacher!)")
        
        subjectref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            
            
            self.dictionary = snapshot.value as! NSDictionary
            
            self.numberOfArray = self.dictionary.count
            
            for (key, value) in self.dictionary{
                
                
                // 最後の階層なのでkeyは使わずにvalueだけ使う
                self.teatures.append(value as! String)
                
            }
            
            var i = 0
            
            while i<self.numberOfArray{
                
                let button = UIButton()
                let title = self.teatures[i]
                button.setTitle(title, for: .normal)
                button.frame = CGRect(x: 0, y: 100*i, width: Int(self.view.frame.size.width), height: 100)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = UIColor.green
                self.view.addSubview(button)
                
                
                
                i+=1
            }
            
            
            
            
        }
        )
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
