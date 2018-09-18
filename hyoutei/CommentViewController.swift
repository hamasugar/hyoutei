//
//  CommentViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/29.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController ,UIScrollViewDelegate {
    var school: String!
    var subject: String!
    var teacher: String!
    var  numberOfArray: Int!
    var dictionary: NSDictionary!
    var teatures = [String]()
    var subjectref: DatabaseReference!
    let scrollView = UIScrollView()
    var i:Int = 0
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teatures = [String]() //ここで一旦からにしておかないと戻ってきたときに後ろにコメントが追加されてしまう
        
        
        scrollView.backgroundColor = MakeView.backgroundColor
        scrollView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: self.width, height:2000)
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        
        subjectref = Database.database().reference().child("/college/\(school!)/\(subject!)/\(teacher!)")
        subjectref.observeSingleEvent(of: .value, with: {(snapshot) in
            self.dictionary = snapshot.value as! NSDictionary
            print (self.dictionary) //ここでは順番通りに来ている　limitもしっかり効いてる
            let tagtostring = self.dictionary!["number"]! as! String
            self.numberOfArray = Int(tagtostring)

            var j = 1
            while j <= self.numberOfArray {
                let stringj = j.description
                self.teatures.append(self.dictionary[stringj] as! String)
                j+=1
            }
            print (self.teatures)

            self.i = 0

            while self.i<self.numberOfArray {
                print (self.i)
                let button = UIButton()
                let time = self.dictionary!["\(self.i+1)time"] as! Int
                let timeDate = NSDate(timeIntervalSince1970: TimeInterval(time))
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                let dateStr: String = formatter.string(from: timeDate as Date)
                // ここの型変換はマジで慣れない　nstag int timeInterval nsdate date と4回型変換がいる
//                let title = "\(self.teatures[self.i]) \(dateStr)"
//                button.setTitle(title, for: .normal)
                
                
                button.frame = CGRect(x: 20, y: MakeView.buttonSpace*(self.i)+15, width: self.width-40, height: MakeView.buttonHeight)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = MakeView.buttonColor
                button.addTarget(self, action: #selector(self.allSentence(sender:)), for: .touchUpInside)
                button.layer.masksToBounds = true
                button.layer.cornerRadius = MakeView.cornerRadius
                self.scrollView.addSubview(button)
                
                let buttonWidth = self.width-40
                
                let buttonLabel1 = UILabel()
                buttonLabel1.backgroundColor = UIColor.white
                buttonLabel1.textColor = UIColor.black
                buttonLabel1.frame = CGRect(x: 10, y: 0, width:Int(buttonWidth*3/4-10) , height: Int(MakeView.buttonHeight))
                buttonLabel1.text = "\(self.teatures[self.i])"
                buttonLabel1.textAlignment = .left
                button.addSubview(buttonLabel1)
                
                let buttonLabel2 = UILabel()
                buttonLabel2.backgroundColor = UIColor.white
                buttonLabel2.textColor = UIColor.black
                buttonLabel2.frame = CGRect(x: buttonWidth*3/4, y: 0, width:buttonWidth/4-10 , height: MakeView.buttonHeight)
                buttonLabel2.font = UIFont.systemFont(ofSize: 11.0)
                buttonLabel2.text = "\(dateStr)"
                buttonLabel2.textAlignment = .right
                button.addSubview(buttonLabel2)
                

                self.i+=1
            }
            
            self.makeUnderButton()
            self.scrollView.contentSize =  CGSize(width: self.width, height: MakeView.buttonSpace*(self.i+2))
            //こうやって後から修正もできる    でもそれは更新しないと反応しなかった　修正同期処理にすれば何とかなった
            
        }
        )
        // Do any additional setup after loading the view.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func goback(sender:UIButton) {
        MakeView.puyopuyo(sender:sender)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func goEdit() {
        performSegue(withIdentifier: "goEdit", sender: nil)
    }
    @objc func reload(){
        loadView()
        viewDidLoad()
    }
    
    
    func makeUnderButton(){
        
        let button = UIButton()
        button.setTitle("←", for: .normal)
        button.frame = CGRect(x: 0, y: Int(self.height)-MakeView.underButtonHeight, width: width/3-10, height: MakeView.underButtonHeight)
        button.addTarget(self, action: #selector(self.goback(sender:)), for: .touchUpInside)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(button)
        
        let button2 = UIButton()
        button2.setTitle("+", for: .normal)
        button2.frame = CGRect(x: width/3, y: Int(self.height)-MakeView.underButtonHeight, width: width/3, height: MakeView.underButtonHeight)
        button2.addTarget(self, action: #selector(self.goEdit), for: .touchUpInside)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(button2)
        
        let button3 = UIButton()
        button3.setTitle("🔁", for: .normal)
        button3.frame = CGRect(x: width*2/3+10, y: Int(self.height)-MakeView.underButtonHeight, width: width/3-10, height: MakeView.underButtonHeight)
        button3.addTarget(self, action: #selector(self.reload), for: .touchUpInside)
        button3.setTitleColor(UIColor.black, for: .normal)
        button3.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(button3)

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC: EditViewController = segue.destination as! EditViewController
        nextVC.ref = self.subjectref
    }
    
    @objc func allSentence(sender:UIButton){
        MakeView.puyopuyo(sender:sender)
        let numberOfButton = Int(sender.frame.minY)/MakeView.buttonSpace
        let allSentence = self.teatures[numberOfButton]
        let alert = UIAlertController(title: "全文", message: allSentence, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        
        
    }

}
