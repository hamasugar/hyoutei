//
//  AddTeacherViewController.swift
//  hyoutei
//
//  Created by user on 2018/09/22.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import Firebase

class AddTeacherViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate {
    
    var ref: DatabaseReference!
    var school: String! //fromBreforeVC
    var subject: String! //fromBreforeVC
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    
    let backButton = UIButton()
    let addButton = UIButton()
    let nameTextField = UITextField()
    let textField = UITextView()
    
    let judgeLabel = UILabel()
    let commentLabel = UILabel()
    
    let picker = UIPickerView()
    let scoreArray = [0,1,2,3,4,5,6,7,8,9,10]
    var score: Int!
    var underLabel = UILabel() // 戻るボタンのみ実装する
    var topLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        textField.delegate = self
        self.view.backgroundColor = MakeView.backgroundColor
        
        self.score = scoreArray.last!/2
        
        topLabel.backgroundColor = MakeView.underButtonColor
        topLabel.frame = CGRect(x: 0, y: 15, width: self.width, height: MakeView.buttonHeight)
        topLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        topLabel.textAlignment = .center
        self.view.addSubview(topLabel)
        if let school = school,let subject = subject {
            topLabel.text = "\(school) \(subject)"
        }
        
        underLabel.frame = CGRect(x: 0, y: self.height-MakeView.underButtonHeight, width: self.width, height: MakeView.underButtonHeight)
        underLabel.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(underLabel)
        
        backButton.setImage(UIImage(named:"back2"), for:.normal)
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        backButton.frame = CGRect(x: 0, y: self.height-MakeView.underButtonHeight+10, width: self.width/3, height: Int(MakeView.underButtonHeight)-20)
        backButton.addTarget(self, action: #selector(self.goBack(sender:)), for: .touchUpInside)
        backButton.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(backButton)
        
        addButton.setTitle(text.post.rawValue, for: .normal)
        addButton.frame = CGRect(x: self.width*3/10, y: self.height*3/4, width: self.width*4/10, height: self.height/10)
        addButton.addTarget(self, action: #selector(self.add(sender:)), for: .touchUpInside)
        addButton.backgroundColor = MakeView.underButtonColor
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = MakeView.cornerRadius
        self.view.addSubview(addButton)
        
        nameTextField.frame =  CGRect(x: 50, y: self.height*2/10, width: self.width-100, height: 50)
        nameTextField.backgroundColor = UIColor.white
        nameTextField.placeholder = text.collegePlaceHolder.rawValue
        self.view.addSubview(nameTextField)
        
        
        textField.frame = CGRect(x: 50, y: self.height*3/10, width: self.width-100, height: self.height*2/10)
        textField.backgroundColor = UIColor.white
        textField.text = text.placeHolder.rawValue
        textField.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.view.addSubview(textField)
        
        self.picker.frame = CGRect(x: self.width/2-50, y: self.height*6/10, width: 100, height: 100)
        self.view.addSubview(picker)
        
        self.judgeLabel.text = text.evaluate.rawValue
        self.judgeLabel.frame = CGRect(x: 0, y: self.height*5/10, width: self.width, height: self.height/10)
        self.judgeLabel.textAlignment = .center
        self.view.addSubview(judgeLabel)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func goBack(sender:UIButton) {
        MakeView.puyopuyo(sender:sender)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func add(sender:UIButton) {
        MakeView.puyopuyo(sender:sender)
        
        if nameTextField.text!.count == 0 || textField.text!.count == 0{
            makeAlert(title: text.margin.rawValue, message: text.marginMessage.rawValue, actionTitle: "OK")
            return
        }
        
        if nameTextField.text!.count > 300 || textField.text!.count > 300{
            makeAlert(title: text.limitOver.rawValue, message: text.limitOverMessage.rawValue, actionTitle: "OK")
            return
        }
        
        let int = Int(NSDate().timeIntervalSince1970)
        let timeDate = NSDate(timeIntervalSince1970: TimeInterval(int))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        let key: String = formatter.string(from: timeDate as Date)
        if let count:Int = UserDefaults.standard.object(forKey: key) as? Int{
            
            UserDefaults.standard.set(count+1, forKey: key)
            
            if count >= 100{
                makeAlert(title: text.monthLimit.rawValue, message: text.monthLimitMessage.rawValue, actionTitle: "OK")
                return
            }
        }
        else{
            UserDefaults.standard.set(1, forKey: key)
        }
        //ここでバリデーションを貼らないと面倒臭いことになる
        if let commentText = self.textField.text,let proName = self.nameTextField.text,let school = self.school, let subject = self.subject {
            
            let varidateRef = Database.database().reference().child("/college/\(school)/\(subject)/\(proName)")
            fetchArray(ref: varidateRef){(response) in
                print (response)
                print (varidateRef)
                if response[0] != "" {
                    self.makeAlert(title: text.doubleComment.rawValue, message: text.doubleCommentMessage.rawValue, actionTitle: "OK")
                }
                else {
                    self.ref.child("\(proName)/number").setValue("1")
                    self.ref.child("\(proName)/1").setValue(commentText)
                    self.ref.child("\(proName)/1time").setValue(Int(NSDate().timeIntervalSince1970))
                    self.ref.child("\(proName)/score").setValue(self.score)
                    self.ref.child("\(proName)/name").setValue(proName)
                    
                    let alert = UIAlertController(title: text.finishPost.rawValue, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: text.close.rawValue, style: .default))
                    self.present(alert, animated: true, completion: {
                        
                        self.textField.text = ""
                        self.nameTextField.text = "" //テキストを空にして連続の投稿を防ぐ
                    })
                    
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scoreArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return scoreArray[row].description
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        score = scoreArray[row]
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.textField.text == text.placeHolder.rawValue {
            self.textField.text = ""
            self.textField.textColor = MakeView.textFieldTextColor
        }
    }
    func makeAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}
