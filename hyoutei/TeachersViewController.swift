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
    var subject: String!//from&to
    var school: String!//from&to
    var teacher: String! //tonextVC
    let scrollView = UIScrollView()
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    let topLabel = UILabel()
    let underLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        makeScrollView()
        
        topLabel.frame = CGRect(x: 0, y: 15, width: self.width, height: MakeView.buttonHeight)
        topLabel.text = "\(school!) \(subject!)"
        topLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        topLabel.backgroundColor = MakeView.underButtonColor
        topLabel.textAlignment = .center
        self.view.addSubview(topLabel)
        
        underLabel.frame = CGRect(x: 0, y: self.height-MakeView.underButtonHeight, width: self.width, height: MakeView.underButtonHeight)
        underLabel.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(underLabel)
        
        self.teachers = [String]()//空にしておかないと戻ってきたときに困る
        let ref = Database.database().reference().child("/college/\(school!)/\(subject!)")
        fetchArray(ref: ref){(response) in
            self.teachers = response
            self.makeButton()
        }
    }

    func makeButton() {
        var i=0
        let count = self.teachers.count
        while i < count {
            let button = UIButton()
            let title = self.teachers[i]
            button.setTitle(title, for: .normal)
            button.frame = CGRect(x: 10, y: MakeView.buttonSpace*(i+1)+15, width: self.width-20, height: MakeView.buttonHeight)
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
        button.setImage(UIImage(named:"back2"), for:.normal)
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.frame = CGRect(x: 0, y: self.height-MakeView.underButtonHeight+10, width: self.width/3, height: Int(MakeView.underButtonHeight)-20)
        button.addTarget(self, action: #selector(self.goback(sender:)), for: .touchUpInside)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(button)
        
        let addbutton = UIButton()
        addbutton.setImage(UIImage(named: "add"), for: .normal)
        addbutton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        addbutton.frame = CGRect(x: self.width/3, y: self.height-MakeView.underButtonHeight+10, width: self.width/3, height: MakeView.underButtonHeight-20)
        addbutton.addTarget(self, action: #selector(self.add), for: .touchUpInside)
        addbutton.setTitleColor(UIColor.black, for: .normal)
        addbutton.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(addbutton)
        
        let reloadbutton = UIButton()
        reloadbutton.setImage(UIImage(named: "reload"), for: .normal)
        reloadbutton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        reloadbutton.frame = CGRect(x: self.width*2/3, y: self.height-MakeView.underButtonHeight+10, width: self.width/3, height: MakeView.underButtonHeight-20)
        reloadbutton.addTarget(self, action: #selector(self.reload), for: .touchUpInside)
        reloadbutton.setTitleColor(UIColor.black, for: .normal)
        reloadbutton.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(reloadbutton)
    }
    
    @objc func onClick(sender: UIButton) {
        MakeView.puyopuyo(sender:sender)
        //ボタンが押されたら押されたボタンの位置つまり高さによってどのボタンが押されたかを間接的に判定する
        let numberOfButton = Int(sender.frame.minY)/MakeView.buttonSpace-1
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
                nextVC.school = self.school!
                nextVC.subject = self.subject!
            
        }
        }
    @objc func goback(sender:UIButton) {
        MakeView.puyopuyo(sender:sender)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func add(){
        performSegue(withIdentifier: "goAdd", sender: nil)
    }
    
    @objc func reload(){
        loadView()
        viewDidLoad()
    }

}
