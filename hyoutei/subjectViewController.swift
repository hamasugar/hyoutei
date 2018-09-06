//
//  subjectViewController.swift
//  hyoutei
//
//  Created by user on 2018/09/01.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class subjectViewController: UIViewController,UIScrollViewDelegate {
    
    
    var subjects = [String]()
    
    var school:String!
    
    var subject:String! //次の画面に表示するための学校を定義する
    
    let scrollView = UIScrollView()
    
    var numberOfDictionary:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        makeScrollView()
        
        let ref = Database.database().reference().child("\(school!)")
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            var dictionary:NSDictionary!
            dictionary = snapshot.value as! NSDictionary
            
            
            
            for (key, _) in dictionary {
                
                self.subjects.append(key as! String)
                
            }
            
            //ボタンを作るための処理をクロージャーの中に入れておかないとスレッドが複数生成されてnumberOfDictionaryが最初の値を参照してしまう
            
            
            self.makeButton()
            
            
            
        })
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func makeButton(){
        
        var i=0
        while i<self.subjects.count{
            
            let button = UIButton()
            let title = self.subjects[i]
            print (title)
            button.setTitle(title, for: .normal)
            button.frame = CGRect(x: 10, y: 100*(i), width: Int(self.view.frame.size.width-20), height: 90)
            button.addTarget(self, action: #selector(self.onClick(sender:)), for: .touchUpInside)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.green
            self.scrollView.addSubview(button)
            
            i+=1
        }
        
        let button = UIButton()
        button.setTitle("戻る", for: .normal)
        button.frame = CGRect(x: 10, y: Int(self.view.frame.size.height-90), width: Int(self.view.frame.size.width-20), height: 90)
        button.addTarget(self, action: #selector(self.goback), for: .touchUpInside)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.green
        self.view.addSubview(button)
        
        
        
    }
    
    
    @objc func onClick(sender: UIButton){
        
        //ボタンが押されたら押されたボタンの位置つまり高さによってどのボタンが押されたかを間接的に判定する
        let numberOfButton = Int(sender.frame.minY)/100
        subject = subjects[numberOfButton]
        print (subject)
         performSegue(withIdentifier: "goTeacher", sender: nil)
    }
    
    func makeScrollView(){
        
        
        scrollView.backgroundColor = UIColor.yellow
        scrollView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2000) //ここが全体の大きさなのかあ
        
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


        let nextVC:teachersViewController = segue.destination as! teachersViewController

        nextVC.school = school!
        nextVC.subject = subject!

    }
    
    @objc func goback(){
        
        self.dismiss(animated: true, completion: nil)
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
