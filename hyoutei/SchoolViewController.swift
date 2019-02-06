//
//  schoolViewController.swift
//  hyoutei
//
//  Created by user on 2018/09/01.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class SchoolViewController: UIViewController, UIScrollViewDelegate {
    var schools = [String]()

    var school: String! // toNextVC
    let scrollView = UIScrollView()
    let topLabel = UILabel()
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeScrollView()
        topLabel.frame = CGRect(x: 0, y: 15, width: self.width, height: MakeView.buttonHeight)
        topLabel.text = text.schoolTopLabel.rawValue
        topLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        topLabel.backgroundColor = MakeView.underButtonColor
        topLabel.textAlignment = .center
        self.view.addSubview(topLabel)
        
        
        let ref = Database.database().reference().child("college")
        
        fetchArray(ref: ref){(response) in
            self.schools = response
            self.makeButton()
        }
        requestReview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeButton() {
        var i=0
        let count = self.schools.count
        while i < count {
            let button = UIButton()
            let title = self.schools[i]
            button.setTitle(title, for: .normal)
            button.frame = CGRect(x: 10, y: MakeView.buttonSpace*(i+1)+15, width: self.width-20, height: MakeView.buttonHeight)
            button.addTarget(self, action: #selector(self.onClick(sender:)), for: .touchUpInside)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = MakeView.buttonColor
            button.layer.masksToBounds = true
            button.layer.cornerRadius = MakeView.cornerRadius
            button.tag = i
            self.scrollView.addSubview(button)
            i+=1
        }
        
        self.scrollView.contentSize =  CGSize(width: CGFloat(self.width), height: CGFloat(MakeView.buttonSpace*(i+2)))
    }
    
    func makeScrollView() {
        scrollView.backgroundColor = MakeView.backgroundColor
        scrollView.frame.size = CGSize(width: self.width, height: self.height)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: self.width, height: MakeView.contentHeight) //ここが全体の大きさなのかあ
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
    }

    @objc func onClick(sender: UIButton) {
        MakeView.puyopuyo(sender:sender)
        let numberOfButton = sender.tag
        school = schools[numberOfButton]
        performSegue(withIdentifier: "goSubject", sender: nil)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC: SubjectViewController = segue.destination as! SubjectViewController
            if let school = school {
                nextVC.school = school
            }
    }
}
