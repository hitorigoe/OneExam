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
import PKHUD


class ExamViewController: UIViewController {
    var postdata:Any?
    var masterArray: [MasterData2] = []
    var isChecked : Bool = true
    var accessIndex : String = "0"
    var aaa : Any?
    var i : Int = 0
    var page: Int = 1
    var maxCnt : Int = 0
    var answer: String?
    var resultPage : Bool = false
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var templateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("aaaaacc")
        dump(postdata)
        

        
        
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
            print(snapshot.key)
            print("DEBUG_PRINT: .childAddedイベントが発生しました。10")
            //print(snapshot.key.propertyList())
            
            let valueDic = snapshot.value as! [String : Any]

            
            print("datastart")
            if self.page - 1 == self.i {
                let masterData = MasterData2(snapshot: snapshot)
                //print(masterData)
                self.masterArray.insert(masterData, at: 0)
                self.aaa = valueDic["title"] as? String

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
                print("vvv")
                print(self.maxCnt)
                print(self.page)
                print("vvv")
                if self.maxCnt == snapshot.key.count  {
                    
                    self.nextButton.setTitle("結果へ進む！"  ,for: .normal)
                    self.resultPage = true
                }
                    
                    
                    //self.contentLabel.text = "\(masterData.content!) "
            }
            self.i = self.i + 1
            print("カウンタ")
            self.maxCnt = self.i
            print(self.maxCnt) // 問題数
            print(self.page)
            
            

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
            button2.isEnabled = true
            button3.isEnabled = true
            button4.isEnabled = true
        } else {
            //sender.setTitle("X", for: .normal)
            button1.backgroundColor = .orange
            button2.isEnabled = false
            button3.isEnabled = false
            button4.isEnabled = false
            dump(button1.currentTitle)
            print("answer")
            print(answer)
            if button1.currentTitle!.contains(answer!) {
                PKHUD.sharedHUD.contentView = CustomHUDView(image: PKHUDAssets.progressCircularImage, title: "正解です！", subtitle: nil)
                PKHUD.sharedHUD.show(onView: view)
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    // Completion Handler
                }
            } else {
                print("不正解")
                PKHUD.sharedHUD.contentView = CustomHUDView(image: PKHUDAssets.crossImage, title: "不正解です。", subtitle: nil)
                PKHUD.sharedHUD.show(onView: view)
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    // Completion Handler
                }
            }
        }
    }
    

    @IBAction func actionButton2(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            button2.backgroundColor = .gray
            button1.isEnabled = true
            button3.isEnabled = true
            button4.isEnabled = true
        } else {
            //sender.setTitle("X", for: .normal)
            button2.backgroundColor = .orange
            button1.isEnabled = false
            button3.isEnabled = false
            button4.isEnabled = false
            if button2.currentTitle!.contains(answer!) {
                print("正解")
                PKHUD.sharedHUD.contentView = CustomHUDView(image: PKHUDAssets.progressCircularImage, title: "正解です！", subtitle: nil)
                PKHUD.sharedHUD.show(onView: view)
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    // Completion Handler
                }
            } else {
                print("不正解")
                PKHUD.sharedHUD.contentView = CustomHUDView(image: PKHUDAssets.crossImage, title: "不正解です。", subtitle: nil)
                PKHUD.sharedHUD.show(onView: view)
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    // Completion Handler
                }
            }
        }
    }
    

    
    @IBAction func actionButton3(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            button3.backgroundColor = .gray
            button1.isEnabled = true
            button2.isEnabled = true
            button4.isEnabled = true
        } else {
            //sender.setTitle("X", for: .normal)
            button3.backgroundColor = .orange
            button1.isEnabled = false
            button2.isEnabled = false
            button4.isEnabled = false
            if button3.currentTitle!.contains(answer!) {
                print("正解")
                PKHUD.sharedHUD.contentView = CustomHUDView(image: PKHUDAssets.progressCircularImage, title: "正解です！", subtitle: nil)
                PKHUD.sharedHUD.show(onView: view)
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    // Completion Handler
                }
                
                
            } else {
                print("不正解")
                PKHUD.sharedHUD.contentView = CustomHUDView(image: PKHUDAssets.crossImage, title: "不正解です。", subtitle: nil)
                PKHUD.sharedHUD.show(onView: view)
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    // Completion Handler
                }
            }
        }
    }
    
    @IBAction func actionButton4(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            button4.backgroundColor = .gray
            button1.isEnabled = true
            button2.isEnabled = true
            button3.isEnabled = true
        } else {
            //sender.setTitle("X", for: .normal)
            button4.backgroundColor = .orange
            button1.isEnabled = false
            button2.isEnabled = false
            button3.isEnabled = false
            if button4.currentTitle!.contains(answer!) {
                print("正解")
                PKHUD.sharedHUD.contentView = CustomHUDView(image: PKHUDAssets.progressCircularImage, title: "正解です！", subtitle: nil)
                PKHUD.sharedHUD.show(onView: view)
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    // Completion Handler
                }
            } else {
                print("不正解")
                PKHUD.sharedHUD.contentView = CustomHUDView(image: PKHUDAssets.crossImage, title: "不正解です。", subtitle: nil)
                PKHUD.sharedHUD.show(onView: view)
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    // Completion Handler
                }
            }
        }
    }
    class CustomHUDView: PKHUDSquareBaseView {
        
        override init(image: UIImage?, title: String?, subtitle: String?) {
            super.init(image: image, title: title, subtitle: subtitle)
            
            titleLabel.textColor = UIColor.lightGray
            
            backgroundColor = UIColor(red: 0xAB/0xFF, green: 0xD2/0xFF, blue: 0xFC/0xFF, alpha: 1.0)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if resultPage == false {
            let examViewController = self.storyboard?.instantiateViewController(withIdentifier:"Exam") as! ExamViewController
            examViewController.page = self.page + 1
            examViewController.postdata = self.postdata
            self.navigationController?.pushViewController(examViewController, animated: true)
        } else {
            let resultViewController = self.storyboard?.instantiateViewController(withIdentifier:"Result") as! ResultViewController
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
    
    
}
