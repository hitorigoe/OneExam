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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser?.uid
        for item in answerBox {
              self.postRef3 = Database.database().reference().child("users_exam_detail").child(userID!).child(self.postdata as! String).child("\(item.key)")
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

        print("aaaa")
        dump(masterArray)
        print("bbbb")
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
        return answerBox.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultTableViewCell
        //dump(masterArray[answerBox.count].title!)
        print("aqaqaqaq")
        //cell.setMasterData2(masterArray[indexPath.row])
        cell.questionLabel.text = masterArray[0].title!
        cell.answerLabel.text = masterArray[0].answer
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170 //変更
    }
    */

}
