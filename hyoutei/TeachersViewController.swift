//
//  teachersViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/29.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class TeachersViewController: UIViewController, UIScrollViewDelegate {

    var teachers = [String]()
    var subject: String!
    var school: String!
    var teacher: String! //次の画面に表示するための教授を定義する
    let scrollView = UIScrollView()
    var numberOfDictionary: Int!
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeScrollView()
        teachers = [String]()
        let ref = Database.database().reference().child("/college/\(school!)/\(subject!)")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            var dictionary: NSDictionary!
            dictionary = snapshot.value as! NSDictionary
            for (key, _) in dictionary {
                self.teachers.append(key as! String)
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

    func makeButton() {
        var i=0
        while i<self.teachers.count {
            let button = UIButton()
            let title = self.teachers[i]
            print (title)
            button.setTitle(title, for: .normal)
            button.frame = CGRect(x: 10, y: MakeView.buttonSpace*(i)+15, width: self.width-20, height: MakeView.buttonHeight)
            button.addTarget(self, action: #selector(self.onClick(sender:)), for: .touchUpInside)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = MakeView.buttonColor
            button.layer.masksToBounds = true
            button.layer.cornerRadius = MakeView.cornerRadius
            self.scrollView.addSubview(button)
            i+=1
        }
        self.scrollView.contentSize =  CGSize(width: self.width, height: MakeView.buttonSpace*(i+2))
        
        let button = UIButton()
        button.setTitle("戻る", for: .normal)
        button.frame = CGRect(x: 10, y: self.height-MakeView.underButtonHeight, width: self.width/3-20, height: MakeView.underButtonHeight)
        button.addTarget(self, action: #selector(self.goback(sender:)), for: .touchUpInside)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(button)
        
        let addbutton = UIButton()
        addbutton.setTitle("教授を追加", for: .normal)
        addbutton.frame = CGRect(x: self.width/3+10, y: self.height-MakeView.underButtonHeight, width: self.width/3-20, height: MakeView.underButtonHeight)
        addbutton.addTarget(self, action: #selector(self.add), for: .touchUpInside)
        addbutton.setTitleColor(UIColor.black, for: .normal)
        addbutton.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(addbutton)
        
        let reloadbutton = UIButton()
        reloadbutton.setTitle("🔁", for: .normal)
        reloadbutton.frame = CGRect(x: self.width*2/3+10, y: self.height-MakeView.underButtonHeight, width: self.width/3-20, height: MakeView.underButtonHeight)
        reloadbutton.addTarget(self, action: #selector(self.reload), for: .touchUpInside)
        reloadbutton.setTitleColor(UIColor.black, for: .normal)
        reloadbutton.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(reloadbutton)
    }
    
    @objc func onClick(sender: UIButton) {
        MakeView.puyopuyo(sender:sender)
        //ボタンが押されたら押されたボタンの位置つまり高さによってどのボタンが押されたかを間接的に判定する
        let numberOfButton = Int(sender.frame.minY)/MakeView.buttonSpace
        teacher = teachers[numberOfButton]
        
        performSegue(withIdentifier: "goComment", sender: nil)
    }
    
    func makeScrollView() {
        scrollView.backgroundColor = MakeView.backgroundColor
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

        if segue.identifier ==  "goComment"{
            let nextVC: CommentViewController = segue.destination as! CommentViewController
            nextVC.school = school!
            nextVC.subject = subject!
            nextVC.teacher = teacher!
        }
        
        if segue.identifier == "goAdd"{
                let nextVC: AddTeacherViewController = segue.destination as! AddTeacherViewController
                nextVC.ref = Database.database().reference().child("college/\(school!)/\(subject!)")
            
        }
        }
    @objc func goback(sender:UIButton) {
        MakeView.puyopuyo(sender:sender)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func add(){
        
        performSegue(withIdentifier: "goAdd", sender: nil)
    }
    
    @objc func reload(){
        loadView()
        viewDidLoad()
    }

}
