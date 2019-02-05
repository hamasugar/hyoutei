//
//  subjectViewController.swift
//  hyoutei
//
//  Created by user on 2018/09/01.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class SubjectViewController: UIViewController, UIScrollViewDelegate {
    var subjects = [String]()

    var school: String! //from&toOtherVC
    var subject: String! //toNextVC
    
    let scrollView = UIScrollView()
    let topLabel = UILabel()
    let underLabel = UILabel()
    let backButton = UIButton()
    
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        makeScrollView()
        
        topLabel.frame = CGRect(x: 0, y: 15, width: self.width, height: MakeView.buttonHeight)
        topLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        topLabel.backgroundColor = MakeView.underButtonColor
        topLabel.textAlignment = .center
        self.view.addSubview(topLabel)
        if let school = school {
            topLabel.text = "\(school)"
        }
        
        underLabel.frame = CGRect(x: 0, y: self.height-MakeView.underButtonHeight, width: self.width, height: MakeView.underButtonHeight)
        underLabel.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(underLabel)
        
        let ref = Database.database().reference().child("/college/\(school!)")
        fetchArray(ref: ref){(response) in
            self.subjects = response
            self.makeButton()
        }
    }
    func makeButton() {
        var i=0
        let count = self.subjects.count
        while i < count {
            let button = UIButton()
            let title = self.subjects[i]
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
        
        backButton.setImage(UIImage(named:"back2"), for:.normal)
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        backButton.frame = CGRect(x: 0, y: self.height-MakeView.underButtonHeight+10, width: self.width/3, height: Int(MakeView.underButtonHeight)-20)
        backButton.addTarget(self, action: #selector(self.goback(sender:)), for: .touchUpInside)
        backButton.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(backButton)
    }

    @objc func onClick(sender: UIButton) {
        MakeView.puyopuyo(sender:sender)
        //ボタンが押されたら押されたボタンの位置つまり高さによってどのボタンが押されたかを間接的に判定する
        let numberOfButton = Int(sender.frame.minY)/MakeView.buttonSpace-1
        subject = subjects[numberOfButton]
        print (subject)
         performSegue(withIdentifier: "goTeacher", sender: nil)
    }

    func makeScrollView() {
        scrollView.backgroundColor = MakeView.backgroundColor
        scrollView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: self.width, height: MakeView.contentHeight) //ここが全体の大きさなのかあ
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC:TeachersViewController = segue.destination as! TeachersViewController
        nextVC.school = school!
        nextVC.subject = subject!
    }
    
    @objc func goback(sender:UIButton) {
        MakeView.puyopuyo(sender:sender)
        self.dismiss(animated: false, completion: nil)
    }
}
