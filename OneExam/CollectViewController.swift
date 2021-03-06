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
import MediaPlayer
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
    var myMoviePlayerView : MPMoviePlayerViewController!
    var moviedata:Any?
    
    @IBOutlet weak var nMemberLabel: UIButton!
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
        if userID != nil {
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
                            self.nMemberLabel.setTitle("", for: .normal)
            })
        } else {
            nMemberLabel.setTitle("会員登録すると成績表示されます", for: .normal)
        }
        print("aabb")
        dump(dataArray)
    }
    
    @IBAction func nMemberBtn(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier:"Login") as! LoginViewController
        
        self.present(loginViewController, animated: true, completion: nil)
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

        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "myapp-background")
        //let session = URLSession(configuration: sessionConfig, delegate: self as! URLSessionDelegate, delegateQueue: nil)
        
        moviedata = self.dataArray[indexPath.row] as! String
        let moviename = moviedata as! String
        print(moviename)
        let documentDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let localURL = URL(fileURLWithPath: documentDirPath + "/" + moviename)
        print(localURL)
        // MPMoviePlayerViewControllerのインスタンスを生成.
        myMoviePlayerView = MPMoviePlayerViewController(contentURL: localURL)
        
        
        
        // 動画の再生が終了した時のNotification.
        
        //NotificationCenter.default.addObserver(self, action: #selector(self.moviePlayBackDidFinish(_:forEvent:)), for: .touchUpInside)
        //name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish,
        //object: myMoviePlayerView.moviePlayer)
        // 画面遷移.
        self.present(myMoviePlayerView, animated: true, completion: nil)
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
