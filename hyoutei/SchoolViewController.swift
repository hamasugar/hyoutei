//
//  schoolViewController.swift
//  hyoutei
//
//  Created by user on 2018/09/01.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase
import StoreKit

class SchoolViewController: UIViewController, UIScrollViewDelegate {
    var schools = [String]()

    var school: String! //次の画面に表示するための学校を定義す
    let scrollView = UIScrollView()
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    let topLabel = UILabel()

    var numberOfDictionary: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeScrollView()
        
        topLabel.frame = CGRect(x: 0, y: 15, width: self.width, height: MakeView.buttonHeight)
        topLabel.text = "大学名を選択"
        topLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        topLabel.backgroundColor = MakeView.underButtonColor
        topLabel.textAlignment = .center
        self.view.addSubview(topLabel)
        
        
        let ref = Database.database().reference().child("college")

        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            var dictionary: NSDictionary!
            dictionary = snapshot.value as! NSDictionary

            for (key, _) in dictionary {
                self.schools.append(key as! String)
            }
            //ボタンを作るための処理をクロージャーの中に入れておかないとスレッドが複数生成されてnumberOfDictionaryが最初の値を参照してしま
            self.makeButton()
        })
        
        if (UserDefaults.standard.object(forKey: "start") as? Int)! == 10, #available(iOS 10.3, *) {
        SKStoreReviewController.requestReview()//ios10.3以降でないと正しく動作しない
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makeButton() {
        var i=0
        while i<self.schools.count {
            let button = UIButton()
            let title = self.schools[i]
            print (title)
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
        
        self.scrollView.contentSize =  CGSize(width: CGFloat(self.width), height: CGFloat(MakeView.buttonSpace*(i+2)))
    }

    @objc func onClick(sender: UIButton) {
        MakeView.puyopuyo(sender:sender)
        //ボタンが押されたら押されたボタンの位置つまり高さによってどのボタンが押されたかを間接的に判定する
        let numberOfButton = Int(sender.frame.minY)/MakeView.buttonSpace-1
        school = schools[numberOfButton]
        performSegue(withIdentifier: "goSubject", sender: nil)
    }
    func makeScrollView() {
        scrollView.backgroundColor = MakeView.backgroundColor
        scrollView.frame.size = CGSize(width: self.width, height: self.height)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: self.width, height: 2000) //ここが全体の大きさなのかあ
        scrollView.bounces = false
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
    }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC: SubjectViewController = segue.destination as! SubjectViewController

        nextVC.school = school!
        }
    }
