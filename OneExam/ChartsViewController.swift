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
    let userDefaults:UserDefaults = UserDefaults.standard
    var newArray:[ChartData2] = []
    let pieView : PieChartView = {
        let set = PieChartView()
        set.translatesAutoresizingMaskIntoConstraints = false
        set.drawHoleEnabled = false
        set.chartDescription?.text = ""
        
        return set
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightdata = (self.view.bounds.height - 350) / 2

    }
    override func viewWillAppear(_ animated: Bool) {
        print("haitta")
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users_true_count").child(userID!).observeSingleEvent(of: .value, with: { (snapshot)  in
            // Get user value
            if let tmp = snapshot.value {
                self.correct_count = tmp as! Int
                // UsersDefaults
                _ = self.userDefaults.integer(forKey: "users_true_count")
                self.userDefaults.set(self.correct_count, forKey: "users_true_count")
                self.userDefaults.synchronize()
            }
            
        })
        
        ref.child("users_test_count").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let tmp2 = snapshot.value {
                self.test_count = tmp2 as! Int * 3
                _ = self.userDefaults.integer(forKey: "users_test_count")
                self.userDefaults.set(self.test_count, forKey: "users_test_count")
                self.userDefaults.synchronize()
            }
        })
        
        
        // Do any additional setup after loading the view.
        var rect = view.bounds
        rect.origin.y += 20
        rect.size.height -= 20

        let chartView = PieChartView(frame: rect)
        let users_true_count: Double = Double(userDefaults.integer(forKey: "users_true_count"))
        let users_test_count: Double = Double(userDefaults.integer(forKey: "users_test_count"))
        
        var dNumber: Double
        dNumber = users_true_count / users_test_count
        let correct_percent2 = ceil(dNumber * 100)
        let tmp = 100 - correct_percent2
        
        //let correct_percent3 = ceil(correct_percent2 ) as! FloatingPoint
        
        let entries = [
            PieChartDataEntry(value: correct_percent2, label: "正解率"),
            PieChartDataEntry(value: tmp, label: "不正解率"),
        ]
        self.userDefaults.removeObject(forKey: "users_true_count")
        self.userDefaults.removeObject(forKey: "users_test_count")
        self.userDefaults.synchronize()
        let set = PieChartDataSet(values: entries, label: "正解数/総問題数 * 100")
        set.colors = ChartColorTemplates.colorful()
        set.colors = [UIColor.red,UIColor.blue]
        
        //set.setColor(UIColor.green, UIColor.blue,alpha:0x1)
        chartView.data = PieChartData(dataSet: set)
        print("ppp")
        print(self.view.bounds.width)
        print(chartView.frame.width)
        chartView.frame = CGRect(x:(self.view.bounds.width - 350) / 2,y:self.heightdata,width: 350,height:350)
        view.addSubview(chartView)
        print("pripri")
        print(newArray)

    }
    /*
    func setChart(){
        view.addSubview(pieView)
        pieView.centerXAnchor.constraint(equalTo:    view.centerXAnchor).isActive = true
        pieView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pieView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        pieView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
    }
    
    func chartData(){
        var data = [PieChartDataEntry]()
        for (key,value) in surveyData{
            
            let entry = PieChartDataEntry(value: Double(value), label: key)
            data.append(entry)
        }
        let chart = PieChartDataSet(values: data, label: "")
        chart.colors = ChartColorTemplates.material()
        chart.sliceSpace = 2
        chart.selectionShift = 5
        chart.xValuePosition = .outsideSlice
        chart.yValuePosition = .outsideSlice
        chart.valueTextColor = .black
        chart.valueLineWidth = 0.5
        chart.valueLinePart1Length = 0.2
        chart.valueLinePart2Length = 4
        chart.drawValuesEnabled = true
        let chartData = PieChartData(dataSet: chart)
        pieView.data = chartData
        
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
