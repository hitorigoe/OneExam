//
//  ExamViewController.swift
//  OneExam
//
//  Created by new torigoe on 2019/03/20.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class ExamViewController: UIViewController {
    var postdata:Any?
    var masterArray: [MasterData2] = []
    var isChecked : Bool = true
    var accessIndex : String = "0"
    var aaa : Any?
    var i : Int = 0
    var page: Int = 1
    var answer: String?
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var templateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        let view = UIView()
        view.frame = CGRect(x:10,y:100,width:self.view.bounds.width - 20,height:250)
        // 枠線の色
        view.layer.borderColor = UIColor.gray.cgColor
        // 枠線の太さ
        view.layer.borderWidth = 3
        // 角丸
        view.layer.cornerRadius = 5
        
        // 角丸にした部分のはみ出し許可 false:はみ出し可 true:はみ出し不可
        view.layer.masksToBounds = true
        self.view.addSubview(view)

        // Do any additional setup after loading the view.
        let rgba = UIColor.gray // ボタン背景色設定
        button1.backgroundColor = rgba                                               // 背景色
        button1.layer.borderWidth = 0                                              // 枠線の幅
        button1.layer.borderColor = UIColor.black.cgColor                            // 枠線の色
        button1.layer.cornerRadius = 5.0 // 角丸のサイズ
        button1.titleEdgeInsets = UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0)
        button1.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        
        button2.backgroundColor = rgba                                               // 背景色
        button2.layer.borderWidth = 0                                              // 枠線の幅
        button2.layer.borderColor = UIColor.black.cgColor                            // 枠線の色
        button2.layer.cornerRadius = 5.0
        button2.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)// 角丸のサイズ
        button2.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button3.backgroundColor = rgba                                               // 背景色
        button3.layer.borderWidth = 0                                              // 枠線の幅
        button3.layer.borderColor = UIColor.black.cgColor                            // 枠線の色
        button3.layer.cornerRadius = 5.0                                             // 角丸のサイズ
        button3.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)
        button3.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button4.backgroundColor = rgba                                               // 背景色
        button4.layer.borderWidth = 0                                              // 枠線の幅
        button4.layer.borderColor = UIColor.black.cgColor                            // 枠線の色
        button4.layer.cornerRadius = 5.0                                             // 角丸のサイズ
        button4.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)
        button4.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let masterRef = Database.database().reference().child("exam").child(postdata as! String)
        
        masterRef.observe(.childAdded, with: { snapshot in
            print("DEBUG_PRINT: .childAddedイベントが発生しました。10")
            //print(snapshot.key.propertyList())
            
            let valueDic = snapshot.value as! [String : Any]
            print("datastart")
            if self.page - 1 == self.i {
                let masterData = MasterData2(snapshot: snapshot)
                //print(masterData)
                self.masterArray.insert(masterData, at: 0)
                self.aaa = valueDic["title"] as? String
                if(self.page == 1) {
                    //self.button1.text = valueDic["title"] as! UILabel
                    self.questionLabel.text = masterData.question
                    self.templateLabel.text = masterData.template
                    self.answer = masterData.answer
                    
                    self.button1.setTitle(masterData.button1  ,for: .normal)
                    self.button2.setTitle(masterData.button2  ,for: .normal)
                    self.button3.setTitle(masterData.button3  ,for: .normal)
                    self.button4.setTitle(masterData.button4  ,for: .normal)
                    //self.button1.setTitle(valueDic["choices"] as! Array for: .normal)
                    //self.button2.setTitle(valueDic["choices"], for: .normal)
                    
                    
                    //self.contentLabel.text = "\(masterData.content!) "
                }
            }
            self.i = self.i + 1
            print("カウンタ")
            print(self.i)
            
            

            // TableViewを再表示する
            //self.tableView.reloadData()
            print("dataend")
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func actionButton1(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            button1.backgroundColor = .gray
        } else {
            //sender.setTitle("X", for: .normal)
            button1.backgroundColor = .orange
            dump(button1.currentTitle)
            print("answer")
            print(answer)
            if button1.currentTitle!.contains(answer!) {
                print("正解")
            } else {
                print("不正解")
            }
        }
    }
    

    @IBAction func actionButton2(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            button2.backgroundColor = .gray
        } else {
            //sender.setTitle("X", for: .normal)
            button2.backgroundColor = .orange
            if button2.currentTitle!.contains(answer!) {
                print("正解")
            } else {
                print("不正解")
            }
        }
    }
    

    
    @IBAction func actionButton3(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            button3.backgroundColor = .gray
        } else {
            //sender.setTitle("X", for: .normal)
            button3.backgroundColor = .orange
            if button3.currentTitle!.contains(answer!) {
                print("正解")
            } else {
                print("不正解")
            }
        }
    }
    
    @IBAction func actionButton4(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            button4.backgroundColor = .gray
        } else {
            //sender.setTitle("X", for: .normal)
            button4.backgroundColor = .orange
            if button4.currentTitle!.contains(answer!) {
                print("正解")
            } else {
                print("不正解")
            }
        }
    }
    
}
