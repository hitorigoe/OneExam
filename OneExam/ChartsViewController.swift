//
//  ChartsViewController.swift
//  OneExam
//
//  Created by new torigoe on 2019/04/04.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {

    @IBOutlet weak var piChartView: UIView!

    let pieView : PieChartView = {
        let set = PieChartView()
        set.translatesAutoresizingMaskIntoConstraints = false
        set.drawHoleEnabled = false
        set.chartDescription?.text = ""
        
        return set
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Pie"
        
       //setChart()
        //chartData()
        // Do any additional setup after loading the view.
        var rect = view.bounds
        rect.origin.y += 20
        rect.size.height -= 20
        let chartView = PieChartView(frame: rect)
        let entries = [
            PieChartDataEntry(value: 80, label: "正解"),
            PieChartDataEntry(value: 20, label: "不正解"),
            ]
        
        let set = PieChartDataSet(values: entries, label: "Data")
        set.colors = ChartColorTemplates.colorful()
        set.colors = [UIColor.red,UIColor.blue]
        
        //set.setColor(UIColor.green, UIColor.blue,alpha:0x1)
        chartView.data = PieChartData(dataSet: set)
        print(self.view.bounds.width)
        print(chartView.frame.width)
        chartView.frame = CGRect(x:(self.view.bounds.width - 350) / 2,y:130,width: 350,height:350)
        view.addSubview(chartView)
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
