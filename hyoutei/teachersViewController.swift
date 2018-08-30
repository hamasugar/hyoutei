//
//  teachersViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/29.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class teachersViewController: UIViewController {
    
    var nextTeacher:String!
    
    var  numberOfArray:Int!
    
    var array:NSDictionary!
    
    var teatures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subjectref = Database.database().reference().child("tokyo/English")
        
        subjectref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.array = snapshot.value as! NSDictionary
            
            self.numberOfArray = self.array.count
            
            for (key, _) in self.array {
                
                self.teatures.append(key as! String)
                
            }
            
           
            var i=0

            while i<self.numberOfArray{
                let button = UIButton()
                let title = self.teatures[i]
                button.setTitle(title, for: .normal)
                button.frame = CGRect(x: 0, y: 100*(i), width: Int(self.view.frame.size.width), height: 100)
                button.addTarget(self, action: #selector(self.onClick(sender:)), for: .touchUpInside)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = UIColor.green
                self.view.addSubview(button)
                
                
                
                i+=1
            }
            
        }
        )
        
        }
        
        
        
        
        
    @objc func onClick(sender: UIButton){
        
        var numberOfButton = Int(sender.frame.minY)/100
        nextTeacher = teatures[numberOfButton]
        
        performSegue(withIdentifier: "goComment", sender: nil)
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let nextVC:CommentViewController = segue.destination as! CommentViewController
        
        nextVC.teacher = nextTeacher!
        
    }
        

        // Do any additional setup after loading the view.
  

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
