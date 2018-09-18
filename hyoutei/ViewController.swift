//
//  ViewController.swift
//  hyoutei
//
//  Created by user on 2018/08/26.
//  Copyright © 2018年 hamasugartanaka. All rights reserved.
//

// TOdo
//
//教授の追加機能
// 大仏とかを点数化して平均を出す
// アイコンとボタンの画像を変える
// チュートリアルを作り込む
//上にラベルがないとわかりにくい
// コードをもっと綺麗にする

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
//        let text = "あいうえお"
//        print(text.md5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func greenButton(_ sender: Any) {
        let rect: CGRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        let aa: CGAffineTransform = CGAffineTransform(translationX: 0, y: 0)
        context!.concatenate(aa)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()!
        let data1 = UIImagePNGRepresentation(screenShot)
        UIGraphicsEndImageContext()
        let image2 = UIImage(named: "ppppp")
        let image3 = UIImage(named: "album")
        let image4 = UIImage(named: "aaaaa")

        let data2 = UIImagePNGRepresentation(image2!)
        let data3 = UIImagePNGRepresentation(image3!)
        let data4 = UIImagePNGRepresentation(image4!)
        let storageRef = Storage.storage().reference()
        storageRef.child("images/" + "1" + ".jpg").putData(data1!, metadata: nil, completion: { metaData, error in
            print(metaData as Any)
            print(error as Any)
        })
        storageRef.child("tanaka/" + "1" + ".jpg").putData(data2!, metadata: nil, completion: { metaData, error in
            print(metaData as Any)
            print(error as Any)
        })
        storageRef.child("tanaka/" + "2" + ".jpg").putData(data3!, metadata: nil, completion: { metaData, error in
            print(metaData as Any)
            print(error as Any)
        })
        storageRef.child("images/" + "4" + ".jpg").putData(data4!, metadata: nil, completion: { metaData, error in
            print(metaData as Any)
            print(error as Any)
            print ("tanaka")
        })
    }
    @IBAction func redButton(_ sender: Any) {
        let tanakaref = Storage.storage().reference().child("tanaka/1.jpg")
        tanakaref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                let image = UIImage(data: data!)
               self.imageView.image = image
        }
        }

}
