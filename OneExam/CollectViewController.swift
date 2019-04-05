//
//  CollectViewController.swift
//  OneExam
//
//  Created by new torigoe on 2019/04/04.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class CollectViewController: UIViewController {

    @IBOutlet weak var collectionVIew: UICollectionView!
    
    @IBOutlet weak var imageView: UICollectionView!
    var dataArray: Array<Any> = []
    
    let photos = "movie"
    
    var estimateWidth = 130.0
    var cellMarginSize = 10
    var selectedImage: UIImage?
    var i: Int = 0
    var label: UILabel?
    
    @IBOutlet weak var nodata: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()


        // Set Delegates
        self.collectionVIew.delegate = self
        self.collectionVIew.dataSource = self
        
        // Register cells
        self.collectionVIew.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        // SetupGrid view
        self.setupGridView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionVIew.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dataArray = []
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users_download").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.key.count > 1 {
                self.label?.text?.removeAll()
            }
            self.i = 0
            for itemSnapShot in snapshot.children {
                //ここで取得したデータを自分で定義したデータ型に入れて、加工する
                var chartData = ChartData(snapshot: itemSnapShot as! DataSnapshot)
                
                self.dataArray.append(chartData.movie!)
                self.i = self.i + 1
            }
            self.collectionVIew.reloadData()
        })
        print("aabb")
        dump(dataArray)
    }
    
    
    func setupGridView() {
        let flow = collectionVIew?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)

    }

}

extension CollectViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("ccdd")
        dump(dataArray)
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        cell.setData(text: self.dataArray[indexPath.row] as! String)
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 7
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        // [indexPath.row] から画像名を探し、UImage を設定
        
        print(indexPath.row)
        selectedImage = UIImage(named: dataArray[indexPath.row] as! String)
        let dlViewController = self.storyboard?.instantiateViewController(withIdentifier:"Download") as! DLViewController
        dlViewController.moviedata = self.dataArray[indexPath.row] as! String
        
        self.present(dlViewController, animated: true, completion: nil)
        
    }

}

extension CollectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: width)
    }
    
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}
