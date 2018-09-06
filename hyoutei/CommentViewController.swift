//
//  CommentViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/29.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController ,UIScrollViewDelegate{
    
    var school:String!
    var subject:String!
    var teacher:String!
    
    var  numberOfArray:Int!
    
    var dictionary:NSDictionary!
    
    var teatures = [String]()
    
    var subjectref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.yellow
        scrollView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        
        
        
        
        
        
        
        subjectref = Database.database().reference().child("/\(school!)/\(subject!)/\(teacher!)")
        
        subjectref.queryLimited(toLast: 5).observeSingleEvent(of: .value, with: {(snapshot) in
            
            
            
            self.dictionary = snapshot.value as! NSMutableDictionary
            print (self.dictionary) //ここでは順番通りに来ている　limitもしっかり効いてる
            self.numberOfArray = self.dictionary.count
            
            let removedDictionary = self.dictionary
            
            for (key,value) in self.dictionary{
                
                
                // 最後の階層なのでkeyは使わずにvalueだけ使う
                self.teatures.append(value as! String)
                print (value)  //このvalueが順番通りに来ていない　for文が順番通りに来ていない証拠　これはもうdictionary型だとどうにもならない
            }
            
            var i = 0
            
            while i<self.numberOfArray{
                
                let button = UIButton()
                let title = self.teatures[i]
                button.setTitle(title, for: .normal)
                button.frame = CGRect(x: 0, y: 100*i, width: Int(self.view.frame.size.width), height: 100)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = UIColor.green
                scrollView.addSubview(button)
                
                
                
                
                i+=1
            }
            let button = UIButton()
            button.setTitle("戻る", for: .normal)
            button.frame = CGRect(x: 10, y: Int(self.view.frame.size.height-90), width: 100, height: 90)
            button.addTarget(self, action: #selector(self.goback), for: .touchUpInside)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.green
            self.view.addSubview(button)
            
            let button2 = UIButton()
            button2.setTitle("追加", for: .normal)
            button2.frame = CGRect(x: Int(self.view.frame.size.width-100), y: Int(self.view.frame.size.height-90), width: 100, height: 90)
            button2.addTarget(self, action: #selector(self.goEdit), for: .touchUpInside)
            button2.setTitleColor(UIColor.black, for: .normal)
            button2.backgroundColor = UIColor.green
            self.view.addSubview(button2)
            
            
            
            
            
        }
        )
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func goback(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func goEdit(){
        
        performSegue(withIdentifier: "goEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC:editViewController = segue.destination as! editViewController
        
        nextVC.ref = self.subjectref
        
        
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
