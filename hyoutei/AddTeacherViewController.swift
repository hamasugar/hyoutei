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
    var width:Int{return Int(self.view.frame.size.width)}
    var height:Int{return Int(self.view.frame.size.height)}
    let button2 = UIButton()
    let addButton = UIButton()
    let textField = UITextView()
    let picker = UIPickerView()
    let scoreArray = [0,1,2,3,4,5,6,7,8,9,10]
    var score:Int = 5
    var textField2 = UITextField()
    let judgeLabel = UILabel()
    let commentLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        textField.delegate = self
        self.view.backgroundColor = MakeView.backgroundColor
        button2.setTitle("戻る", for: .normal)
        button2.frame = CGRect(x: 20, y: Int(self.height-90), width: 100, height: 90)
        button2.addTarget(self, action: #selector(self.goBack(sender:)), for: .touchUpInside)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(button2)
        
        addButton.setTitle("投稿", for: .normal)
        addButton.frame = CGRect(x: Int(self.width/2-50), y: Int(self.height*8/10), width: 100, height: 90)
        addButton.addTarget(self, action: #selector(self.add(sender:)), for: .touchUpInside)
        addButton.setTitleColor(UIColor.black, for: .normal)
        addButton.backgroundColor = MakeView.underButtonColor
        self.view.addSubview(addButton)
        
        textField2.frame =  CGRect(x: 50, y: self.height*2/10, width: self.width-100, height: 50)
        textField2.backgroundColor = UIColor.white
        textField2.placeholder = "教授の名前を記入"
        self.view.addSubview(textField2)
        
        
        textField.frame = CGRect(x: 50, y: self.height*3/10, width: self.width-100, height: self.height*2/10)
        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        textField.text = "受けた授業やコメントを記入"
        textField.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.view.addSubview(textField)
        
        self.picker.frame = CGRect(x: self.width/2-50, y: self.height*6/10, width: 100, height: 100)
        self.view.addSubview(picker)
        
        self.judgeLabel.text = "教授を１０点満点で評価してください"
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
    
    @objc func add(sender:UIButton){
        MakeView.puyopuyo(sender:sender)
        
        if textField2.text!.count == 0 || textField.text!.count == 0{
            let alert = UIAlertController(title: "空白があります", message: "教授名とテキストを入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if textField2.text!.count > 300 || textField.text!.count > 300{
            let alert = UIAlertController(title: "文字数制限オーバー", message: "300文字以内で入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let int = Int(NSDate().timeIntervalSince1970)
        let timeDate = NSDate(timeIntervalSince1970: TimeInterval(int))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        let key: String = formatter.string(from: timeDate as Date)
        if let count:Int = UserDefaults.standard.object(forKey: key) as? Int{
            
            UserDefaults.standard.set(count+1, forKey: key)
            print (key)
            
            if count >= 100{
                let alert = UIAlertController(title: "投稿数が制限を超えています", message: "投稿は１ヶ月に１００件までです", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        }
        else{
            UserDefaults.standard.set(1, forKey: key)
        }
        
        
            self.ref.child("\(self.textField2.text!)/number").setValue("1")
            self.ref.child("\(self.textField2.text!)/1").setValue(self.textField.text)
            self.ref.child("\(self.textField2.text!)/1time").setValue(Int(NSDate().timeIntervalSince1970))
            self.ref.child("\(self.textField2.text!)/score").setValue(self.score)
            self.ref.child("\(self.textField2.text!)/name").setValue(self.textField2.text!)
            
       
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return scoreArray[row].description
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        score = scoreArray[row]
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.textField.text == "受けた授業やコメントを記入"{
            
            self.textField.text = ""
            self.textField.textColor = UIColor.black
        }
        
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
