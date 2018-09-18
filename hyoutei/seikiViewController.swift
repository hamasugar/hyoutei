//
//  seikiViewController.swift
//  hyoutei
//
//  Created by user on 2018/09/10.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

import UIKit
import StoreKit

class SeikiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var textField: UITextField!
    @IBAction func button1(_ sender: Any) {
        let string = self.textField.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        print (result)
        SKStoreReviewController.requestReview()
    }
}
