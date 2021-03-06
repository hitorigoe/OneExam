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
import SVProgressHUD



class ExamViewController: UIViewController {
    
    var postdata:Any?
    var masterArray: [MasterData2] = []
    var newArray: Array<Any> = ["aaa","bbb"]
    var isChecked : Bool = true
    var isChecked1 : Bool = true
    var isChecked2 : Bool = true
    var isChecked3 : Bool = true
    var isChecked4 : Bool = true
    
    var accessIndex : String = "0"
    var aaa : Any?
    var i : Int = 0
    var j : Int = 0
    var q : Int = 0
    var page: Int = 1
    var maxCnt : Int = 0
    var answer: String?
    var resultPage : Bool = false
    var postDic : [Int:[String:Any]]?
    var postRef3 :DatabaseReference!
    var immediately : Bool = false
    var answerBox : [String:String] = [:]
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var templateLabel: UILabel!
    @IBOutlet weak var urya: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // 要素をとる方法
        print("fff")
        print(self.view.bounds.height)
        _ = Database.database().reference().child("exam").child(self.postdata as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.q = 0
            for _ in snapshot.children {
                self.q = self.q + 1
            }
        })
        
        let view = UIView()
        //view.frame = CGRect(x:10,y:50,width:self.view.bounds.width - 20,height:self.view.bounds.height * 1/4 )
        // 枠線の色
        //view.layer.borderColor = UIColor.gray.cgColor
        // 枠線の太さ
        view.layer.borderWidth = 10
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
        button1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button1.layer.cornerRadius = 5.0 // 角丸のサイズ
        
        let rate1 = ceil(self.view.bounds.height * 0.012)
        print("aaa")
        print(rate1)
        button1.titleEdgeInsets = UIEdgeInsets(top: rate1, left: rate1, bottom: rate1, right: rate1)
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
    
    
    override func didMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.answerBox = self.answerBox
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        answerBox.forEach { item in

            appDelegate.answerBox[item.key] = item.value
            if String(item.key) == "answer" + String(self.page) {
                var tmp = "button" + String(self.page) as Any as? UIButton

            }
        }
        answerBox = appDelegate.answerBox

        let masterRef = Database.database().reference().child("exam").child(postdata as! String)
        
        var mojistr = "answer" + String(self.page)
        if answerBox[mojistr] != nil {
            answerBox.forEach { item in
                
                if String(item.key) == mojistr {

                    var tmp = String(item.value)

                    if tmp.contains("button1")  {
                        button1.backgroundColor = .orange
                        isChecked = false
                        button2.isEnabled = false
                        button3.isEnabled = false
                        button4.isEnabled = false
                    } else if tmp.contains("button2") {
                        
                        button2.backgroundColor = .orange
                        isChecked = false
                        button1.isEnabled = false
                        button3.isEnabled = false
                        button4.isEnabled = false
                    } else if tmp.contains("button3") {
                        button3.backgroundColor = .orange
                        isChecked = false
                        button1.isEnabled = false
                        button2.isEnabled = false
                        button4.isEnabled = false
                    } else if tmp.contains("button4") {
                        button4.backgroundColor = .orange
                        isChecked = false
                        button1.isEnabled = false
                        button2.isEnabled = false
                        button3.isEnabled = false
                    }
                    
                }
            }
            
        }
        masterRef.observe(.childAdded, with: { snapshot1 in
        
            _ = snapshot1.value
            
            if self.page <= self.q {
                if Int(snapshot1.key as String)! == self.page {
                    var masterData = MasterData2(snapshot: snapshot1)

                    self.masterArray.insert(masterData, at: self.j)
                    self.questionLabel.text = masterData.question
                    self.urya.text = "正しいものを選べ。"
                    //self.templateLabel.text = masterData.template
                    //self.templateLabel.text = "下記の中から正しいものを選んでください。"
                    self.answer = masterData.answer
                    
                    self.button1.setTitle(masterData.button1  ,for: .normal)
                    self.button2.setTitle(masterData.button2  ,for: .normal)
                    self.button3.setTitle(masterData.button3  ,for: .normal)
                    self.button4.setTitle(masterData.button4  ,for: .normal)
                    self.j = self.j + 1
                    if self.page == self.q  {
                        self.nextButton.setTitle("結果へ進む！"  ,for: .normal)
                        self.resultPage = true
                    }
                }
            }
            self.i = self.i + 1
            self.maxCnt = self.i
        })
    }

    
    @IBAction func actionButton1(_ sender: UIButton) {
        
        isChecked = !isChecked
        print(isChecked)
        
        if isChecked {
            button1.backgroundColor = .gray
            button2.isEnabled = true
            button3.isEnabled = true
            button4.isEnabled = true
        } else {
            
            button1.backgroundColor = .orange
            button2.isEnabled = false
            button3.isEnabled = false
            button4.isEnabled = false
            if button1.currentTitle!.contains(answer!) {
                
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.showSuccess(withStatus: "正解です！！")
                SVProgressHUD.dismiss(withDelay: 1)
                self.answerBox["answer\(self.page)"] = "true:button1"
                
            } else {
                
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.setForegroundColor(UIColor.red)
                SVProgressHUD.dismiss(withDelay: 1)
                SVProgressHUD.showError(withStatus: "不正解です>_<")
                
                self.answerBox["answer\(self.page)"] = "false:button1"
                
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
                
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.showSuccess(withStatus: "正解です！！")
                SVProgressHUD.dismiss(withDelay: 1)
                self.answerBox["answer\(self.page)"] = "true:button2"

            } else {

                
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.setForegroundColor(UIColor.red)
                SVProgressHUD.dismiss(withDelay: 1)
                SVProgressHUD.showError(withStatus: "不正解です>_<")
                self.answerBox["answer\(self.page)"] = "false:button2"
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

                
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.dismiss(withDelay: 1)
                SVProgressHUD.showSuccess(withStatus: "正解です！！")
                self.answerBox["answer\(self.page)"] = "true:button3"
            } else {
                
                
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.dismiss(withDelay: 1)
                SVProgressHUD.setForegroundColor(UIColor.red)
                SVProgressHUD.dismiss(withDelay: 1)
                SVProgressHUD.showError(withStatus: "不正解です>_<")
                self.answerBox["answer\(self.page)"] = "false:button3"
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
                
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.dismiss(withDelay: 1)
                SVProgressHUD.showSuccess(withStatus: "正解です！！")
                self.answerBox["answer\(self.page)"] = "true:button4"
            } else {
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.setForegroundColor(UIColor.red)
                SVProgressHUD.dismiss(withDelay: 1)
                SVProgressHUD.showError(withStatus: "不正解です>_<")
                self.answerBox["answer\(self.page)"] = "false:button4"
                
            }
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        if resultPage == false {
            print("count")
            print(page)
            print("countend")
            var examViewController = self.storyboard?.instantiateViewController(withIdentifier:"Exam") as! ExamViewController
            examViewController.page = self.page + 1
            examViewController.postdata = self.postdata
            examViewController.answerBox = self.answerBox
            //examViewController.isChecked = self.isChecked
            self.navigationController?.pushViewController(examViewController, animated: true)
        } else {
            let resultViewController = self.storyboard?.instantiateViewController(withIdentifier:"Result") as! ResultViewController
            resultViewController.answerBox = self.answerBox
            resultViewController.postdata = self.postdata
            resultViewController.masterArray = self.masterArray
            resultViewController.newArray = self.newArray
            
            button1.backgroundColor = .gray
            button2.backgroundColor = .gray
            button3.backgroundColor = .gray
            button4.backgroundColor = .gray
            button1.isEnabled = true
            button2.isEnabled = true
            button3.isEnabled = true
            button4.isEnabled = true
             self.navigationController?.pushViewController(resultViewController, animated: true)
            
        }
    }
    
}

