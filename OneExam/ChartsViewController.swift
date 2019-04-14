//
//  ChartsViewController.swift
//  OneExam
//
//  Created by new torigoe on 2019/04/04.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseAuth
import FirebaseStorage


class ChartsViewController: UIViewController {

    @IBOutlet weak var piChartView: UIView!
    var correct_count: Int = 0
    var test_count: Int = 0
    var qqq: Int = 0
    var heightdata: CGFloat!
    var entries: [PieChartDataEntry]?
    var userDefaults:UserDefaults = UserDefaults.standard
    var pieView : PieChartView = {
        var set = PieChartView()
        set.translatesAutoresizingMaskIntoConstraints = false
        set.drawHoleEnabled = false
        set.chartDescription?.text = ""
        
        return set
    }()
    
    @IBOutlet weak var receivecount: UILabel!
    @IBOutlet weak var correctcount: UILabel!
    @IBOutlet weak var examcount: UILabel!
   
    
    
    @IBOutlet weak var nmemberLabel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("aaa")
        self.heightdata = (self.view.bounds.height - 350) / 2
        var ref = Database.database().reference()
        var userID = Auth.auth().currentUser?.uid
        if userID != nil {
            nmemberLabel.setTitle("", for: .normal)
            ref.child("users_true_count").child(userID!).observe( .value, with: { (snapshot)  in
                // Get user value
                if snapshot.value is NSNull {

                } else {
                    self.correct_count = snapshot.value as! Int
                    self.correctcount.text = "総正解数：\(self.correct_count)"
                    // UsersDefaults
                    _ = self.userDefaults.integer(forKey: "users_true_count")
                    self.userDefaults.set(self.correct_count, forKey: "users_true_count")
                    self.userDefaults.synchronize()
                }
                
            })
            
            ref.child("users_test_count").child(userID!).observe(.value, with: { (snapshot) in
                // Get user value
                if snapshot.value is NSNull {

                } else {
                    
                    self.test_count = snapshot.value as! Int * 3
                    self.receivecount.text = "テスト受講回数：\(snapshot.value as! Int)"
                    self.examcount.text = "総問題数：\(snapshot.value as! Int * 3)"
                    
                    _ = self.userDefaults.integer(forKey: "users_test_count")
                    self.userDefaults.set(self.test_count, forKey: "users_test_count")
                    self.userDefaults.synchronize()
                }
            })
        } else {
            nmemberLabel.setTitle("会員登録すれば成績表示されます", for: .normal)
            
        }
        
        // Do any additional setup after loading the view.
        var rect = view.bounds
        rect.origin.y += 20
        rect.size.height -= 20
        
        var chartView = PieChartView(frame: rect)
        var users_true_count: Double = Double(userDefaults.integer(forKey: "users_true_count"))
        var users_test_count: Double = Double(userDefaults.integer(forKey: "users_test_count"))

        var dNumber: Double
        dNumber = users_true_count / users_test_count
        var correct_percent2 = ceil(dNumber * 100)
        var tmp = 100 - correct_percent2
        
        //let correct_percent3 = ceil(correct_percent2 ) as! FloatingPoint
        var entries = [
            PieChartDataEntry(value: 50, label: "結果表示"),
            PieChartDataEntry(value: 50, label: "結果表示"),
        ]
        entries = [
            PieChartDataEntry(value: correct_percent2, label: ""),
            PieChartDataEntry(value: tmp, label: ""),
        ]
        self.userDefaults.removeObject(forKey: "users_true_count")
        self.userDefaults.removeObject(forKey: "users_test_count")
        self.userDefaults.synchronize()
        var set = PieChartDataSet(values: entries, label: "")
        set.colors = ChartColorTemplates.colorful()
        set.colors = [UIColor.red,UIColor.blue]
        
        //set.setColor(UIColor.green, UIColor.blue,alpha:0x1)
        chartView.data = PieChartData(dataSet: set)
        
        print(self.view.bounds.width)
        
        if self.view.bounds.width > 350.0 {
            chartView.frame = CGRect(x:(self.view.bounds.width - 350) / 2,y:self.heightdata,width: 350,height:350)
            //view.addSubview(chartView)
        } else {
            chartView.frame = CGRect(x:(self.view.bounds.width - 270) / 2,y:self.heightdata + 100 ,width: 270,height:270)
            //view.addSubview(chartView)
        }
        
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
        self.userDefaults.removeObject(forKey: "users_true_count")
        self.userDefaults.removeObject(forKey: "users_test_count")
    }
    override func viewWillAppear(_ animated: Bool) {
        print("bbb")
        var ref = Database.database().reference()
        var userID = Auth.auth().currentUser?.uid
        print(userID)
        if userID != nil {
            nmemberLabel.setTitle("", for: .normal)
            ref.child("users_true_count").child(userID!).observe(.value, with: { (snapshot)  in
            // Get user value
                if snapshot.value is NSNull {

                } else {
                    self.correct_count = snapshot.value as! Int
                    self.correctcount.text = "総正解数：\(snapshot.value as! Int)"
                    // UsersDefaults
                    _ = self.userDefaults.integer(forKey: "users_true_count")
                    self.userDefaults.set(self.correct_count, forKey: "users_true_count")
                    self.userDefaults.synchronize()
                }
            
            })
        
        ref.child("users_test_count").child(userID!).observe(.value, with: { (snapshot) in
            // Get user value
                if snapshot.value is NSNull {

                } else {
                    self.test_count = snapshot.value as! Int * 3
                    self.receivecount.text = "テスト受講回数：\(snapshot.value as! Int)"
                    self.examcount.text = "総問題数：\(snapshot.value as! Int * 3)"
                
                    _ = self.userDefaults.integer(forKey: "users_test_count")
                    self.userDefaults.set(self.test_count, forKey: "users_test_count")
                    self.userDefaults.synchronize()
                }
            })
        } else {
            self.userDefaults.removeObject(forKey: "users_true_count")
            self.userDefaults.removeObject(forKey: "users_test_count")
            self.userDefaults.synchronize()
            self.test_count = 0
            self.receivecount.text = ""
            self.examcount.text = ""
            self.correctcount.text = ""
            self.nmemberLabel.setTitle("会員登録すると成績表示されます", for: .normal)
            var aaa = [
                PieChartDataEntry(value: 0, label: ""),
                PieChartDataEntry(value: 0, label: ""),
            ]
            var set = PieChartDataSet(values: aaa, label: "")
            set.colors = ChartColorTemplates.colorful()
            set.colors = [UIColor.blue]
            
            //set.setColor(UIColor.green, UIColor.blue,alpha:0x1)
            var rect = view.bounds
            rect.origin.y += 20
            rect.size.height -= 20
            
            var chartView = PieChartView(frame: rect)
            chartView.data = PieChartData(dataSet: set)
            
            
            if self.view.bounds.width > 350.0 {
                chartView.frame = CGRect(x:(self.view.bounds.width - 350) / 2,y:self.heightdata,width: 350,height:350)
                view.addSubview(chartView)
            } else {
                chartView.frame = CGRect(x:(self.view.bounds.width - 270) / 2,y:self.heightdata + 100 ,width: 270,height:270)
                view.addSubview(chartView)
                
            }
        }
        
        // Do any additional setup after loading the view.
        if userID != nil {
        var rect = view.bounds
        rect.origin.y += 20
        rect.size.height -= 20

        var chartView = PieChartView(frame: rect)
        var users_true_count: Double = Double(userDefaults.integer(forKey: "users_true_count"))
        var users_test_count: Double = Double(userDefaults.integer(forKey: "users_test_count"))

        var dNumber: Double
        dNumber = users_true_count / users_test_count
        var correct_percent2 = ceil(dNumber * 100)
        var tmp = 100 - correct_percent2
        
        //let correct_percent3 = ceil(correct_percent2 ) as! FloatingPoint
        
        var entries = [
            PieChartDataEntry(value: correct_percent2, label: "正解率"),
            PieChartDataEntry(value: tmp, label: "不正解率"),
        ]
        self.userDefaults.removeObject(forKey: "users_true_count")
        self.userDefaults.removeObject(forKey: "users_test_count")
        self.userDefaults.synchronize()
        var set = PieChartDataSet(values: entries, label: "正解数/総問題数 * 100")
        set.colors = ChartColorTemplates.colorful()
        set.colors = [UIColor.red,UIColor.blue]
        
        //set.setColor(UIColor.green, UIColor.blue,alpha:0x1)
        chartView.data = PieChartData(dataSet: set)

        
        if self.view.bounds.width > 350.0 {
            chartView.frame = CGRect(x:(self.view.bounds.width - 350) / 2,y:self.heightdata,width: 350,height:350)
            view.addSubview(chartView)
        } else {
            chartView.frame = CGRect(x:(self.view.bounds.width - 270) / 2,y:self.heightdata + 100 ,width: 270,height:270)
            view.addSubview(chartView)
        }
        } else {
            var aaa = [
                PieChartDataEntry(value: 0, label: "正解率"),
                PieChartDataEntry(value: 0, label: "不正解率"),
            ]
            var set = PieChartDataSet(values: aaa, label: "正解数/総問題数 * 100")
            set.colors = ChartColorTemplates.colorful()
            set.colors = [UIColor.red,UIColor.blue]
            
            //set.setColor(UIColor.green, UIColor.blue,alpha:0x1)
            var rect = view.bounds
            rect.origin.y += 20
            rect.size.height -= 20
            
            var chartView = PieChartView(frame: rect)
            chartView.data = PieChartData(dataSet: set)
            
            
            if self.view.bounds.width > 350.0 {
                chartView.frame = CGRect(x:(self.view.bounds.width - 350) / 2,y:self.heightdata,width: 350,height:350)
                view.addSubview(chartView)
            } else {
                chartView.frame = CGRect(x:(self.view.bounds.width - 270) / 2,y:self.heightdata + 100 ,width: 270,height:270)
                view.addSubview(chartView)
                
            }
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    
    @IBAction func nMemberButton(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier:"Login") as! LoginViewController
        
        self.present(loginViewController, animated: true, completion: nil)
    }
}
