//
//  HomeViewController.swift
//  OneExam
//
//  Created by new torigoe on 2019/03/20.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var observing = false
    var masterArray: [MasterData] = []
    var answerBox : [String:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "MasterTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
        // テーブルセルのタップを無効にする
        //tableView.allowsSelection = false
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        print("ここを通るタイミング")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "MasterTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
        // テーブルセルのタップを無効にする
        //tableView.allowsSelection = false
        
            if self.observing == false {
                let masterRef = Database.database().reference().child("exam")
                masterRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。1")
                    print(snapshot)
                    
                    
                    
                    // MasterDataクラスを生成して受け取ったデータを設定する
                        let masterData = MasterData(snapshot: snapshot)
                        self.masterArray.insert(masterData, at: 0)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                })
                // 要素が変更されたら該当のデータをmasterArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                masterRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。2")
                    
                    
                        let masterData = MasterData(snapshot: snapshot)
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 1
                        for master in self.masterArray {
                            if master.id == masterData.id {
                                index = self.masterArray.firstIndex(of: master)!
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.masterArray.remove(at: index)
                        
                        // 削除したところに更新済みのデータを追加する
                        self.masterArray.insert(masterData, at: index)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                })
                
                // DatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
        } else {
            if observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                masterArray = []
                tableView.reloadData()
                // オブザーバーを削除する
                Database.database().reference().removeAllObservers()
                
                // DatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observing = false
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MasterTableViewCell
        cell.setMasterData(masterArray[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MasterTableViewCell
        
        let alert: UIAlertController = UIAlertController(title: "中国語試験", message: "試験を開始します。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier:"Navi") as! UINavigationController
            let examViewController = navigationController.topViewController  as! ExamViewController
            
            examViewController.postdata = self.masterArray[indexPath.row].id
            examViewController.answerBox = self.answerBox
            self.present(navigationController, animated: true, completion: nil)
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }

    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        _ = masterArray[indexPath!.row]
    }

}
