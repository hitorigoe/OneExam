//
//  ResultViewController.swift
//  OneExam
//
//  Created by new torigoe on 2019/03/20.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var answerBox : [String:Bool] = [:]
    var postdata:Any?
    var postRef3 :DatabaseReference!
    var masterArray: [MasterData2] = []
    var resultArray: [ResultData] = []
    var newArray:Array<Any> = []
    var value1: Any?
    var question: String?
    var answer:String?
    var img2:UIImage?
    var img:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("resultArrayの初期値")
        dump(resultArray.count)
        img2 = UIImage(named:"batsu")
        img = UIImage(named:"maru")
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        for item in answerBox {
              self.postRef3 = ref.child("users_exam_detail").child(userID!).child(self.postdata as! String).child("\(item.key)")
              self.postRef3.setValue(item.value)
           // Database.database().reference().child("exam").child(postdata as! String).observe(.childAdded, with: { snapshot in
           //     // Get user value
           //
           //     let resultData = ResultData(snapshot: snapshot)
           //     self.resultArray.insert(resultData, at: 0)
           //     // ...
           // }) { (error) in
           //     print(error.localizedDescription)
           // }

            
              
        }
        ref.child("exam").child(self.postdata as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for itemSnapShot in snapshot.children {
                //ここで取得したデータを自分で定義したデータ型に入れて、加工する
                var resultData = ResultData(snapshot: itemSnapShot as! DataSnapshot)
                self.resultArray.insert(resultData!, at: 0)
                print("post")
                print("ここは何回？")
                dump(self.resultArray.count)
                self.tableView.reloadData()
            }
        })
        
        
        tableView.delegate = self
        tableView.dataSource = self
        //initTableView()

        let nib = UINib(nibName: "ResultTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.rowHeight = UITableView.automaticDimension

        // テーブル行の高さの概算値を設定しておく
        // 高さ概算値 = 「縦横比1:1のUIImageViewの高さ(=画面幅)」+「いいねボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)」
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultTableViewCell
        print("tableにはいった1")
        print(indexPath.row)
        dump(answerBox)
        print("tableにはいった2")
        //cell.setResultData(indexPath)
        cell.questionLabel.text = resultArray[indexPath.row].question
        cell.answerLabel.text = resultArray[indexPath.row].answer

        var str3:String = "answer" + String(indexPath.row + 1)
        if answerBox[str3]! {
            cell.imgView.image = img
        } else {
            cell.imgView.image = img2
        }
        print("hoge")
        print(answerBox[str3] as Any)
        //cell.imgView.image = answerBox
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultTableViewCell
        
        let avViewController = self.storyboard?.instantiateViewController(withIdentifier:"AV") as! AVPlayerViewController
        self.navigationController?.pushViewController(avViewController, animated: true)
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170 //変更
    }
    */

}
