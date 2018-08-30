//
//  createViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/29.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class createViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var textField1: UITextField!
    
    
    @IBAction func createButton(_ sender: Any) {
        
        
         var ref = Database.database().reference()
        
        
        var suzukiref = ref.child("tokyo/English/suzuki")
        suzukiref.observeSingleEvent(of: .value, with:{ (snapshot) in
            
            
            let value:NSDictionary = snapshot.value as! NSDictionary
            let numberOfComments:Int = value["number"]! as! Int
            let number2 = (numberOfComments+1).description
            
            
            suzukiref.child("number").setValue(numberOfComments+1)
             ref.child("tokyo/English/suzuki/\(number2)").setValue([self.textField1.text,0,0])
            
            
            
            
            
            
        })
        
    
        
        
        print ("aaaaa")
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
