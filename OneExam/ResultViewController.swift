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
import FirebaseStorage
import MediaPlayer
import SVProgressHUD

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // ダウンロード完了時の処理
        
        print("didFinishDownloading")
        
        do {
            if let data = NSData(contentsOf: location) {
                
                let fileExtension = location.pathExtension
                let filePath = getSaveDirectory() + getIdFromDateTime() + "." + fileExtension
                
                print(filePath)
                
                try data.write(toFile: filePath, options: .atomic)
                //HUDの処理
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.showSuccess(withStatus: "ダウンロード完了！")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        } catch let error as NSError {
            print("download error: \(error)")
        }
    }
    func getIdFromDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return dateFormatter.string(from: Date())
    }
    // 保存するディレクトリのパス
    func getSaveDirectory() -> String {
        
        let fileManager = Foundation.FileManager.default
        
        // ライブラリディレクトリのルートパスを取得して、それにフォルダ名を追加
        let path = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.libraryDirectory, Foundation.FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/DownloadFiles/"
        
        // ディレクトリがない場合は作る
        if !fileManager.fileExists(atPath: path) {
            createDir(path: path)
        }
        
        
        return path
    }
    
    func createDir(path: String) {
        do {
            let fileManager = Foundation.FileManager.default
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("createDir: \(error)")
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var answerBox : [String:String] = [:]
    var postdata:Any?
    var postRef3 :DatabaseReference!
    var postRef4 :DatabaseReference!
    var postRef5 :DatabaseReference!
    var masterArray: [MasterData2] = []
    var resultArray: [ResultData] = []
    var newArray:Array<Any> = []
    var value1: Any?
    var question: String?
    var answer:String?
    var img2:UIImage?
    var img:UIImage?
    var i:Int = 0
    var tmp:Bool? = false
    var truecount:Int = 0
    var falsecount:Int = 0
    var tmpcount:Int = 0
    
    var image1: UIImage!
    var streamurl: String?
    
    
    var myMoviePlayerView : MPMoviePlayerViewController!
    var moviedata:Any?
    var label:UILabel!
    
    @IBOutlet weak var aLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        print("resultArrayの初期値")
        dump(resultArray.count)
        img2 = UIImage(named:"batsu")
        img = UIImage(named:"maru")
        let userID = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference()
        // 解答データ上書き
        print("ここでとめる")
        dump(answerBox)
        for item in answerBox {
              self.postRef3 = ref.child("users_exam_detail").child(userID!).child(self.postdata as! String).child("\(item.key)")
              self.postRef3.setValue(item.value)
            if item.value.contains("true") {
                tmpcount = tmpcount + 1
            }
        }
        ref.child("exam").child(self.postdata as! String).child("1").child("streamurl").observeSingleEvent(of: .value, with: { (snapshot) in
            let valueDictionary = snapshot.value as! String
            print(valueDictionary)
            self.streamurl = valueDictionary as String
        })
        
        ref.child("users_test_count").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            print("users_test_count")
            var testcount = snapshot.value
            print(testcount)
            print("testcount")
            
            if var aa = testcount {
                let bb = testcount as! Int + 1
                self.postRef4 = ref.child("users_test_count").child(userID!)
                self.postRef4.setValue(bb)
            }
            
        })
        
        ref.child("users_true_count").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            var truecount = snapshot.value
            print(truecount)
            print("truecount")
            if var cc = truecount {
                let dd = truecount as! Int + self.tmpcount
                self.postRef5 = ref.child("users_true_count").child(userID!)
                self.postRef5.setValue(dd)
            }
        })
        
        // answerBoxの中身をみる
        //var str3:String = "answer" + String(indexPath.row + 1)
        
        ref.child("exam").child(self.postdata as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for itemSnapShot in snapshot.children {
                //ここで取得したデータを自分で定義したデータ型に入れて、加工する
                var resultData = ResultData(snapshot: itemSnapShot as! DataSnapshot)
                self.resultArray.insert(resultData!, at: self.i)
                print("post")
                print("ここは何回？")
                dump(self.resultArray.count)
                self.tableView.reloadData()
                self.i = self.i + 1
                
            }
        })
        
        
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
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultTableViewCell

        //cell.setResultData(indexPath)
        cell.questionLabel.text = resultArray[indexPath.row].question
        cell.answerLabel.text = resultArray[indexPath.row].answer

        var str3:String = "answer" + String(indexPath.row + 1)
        
        //if answerBox[str3] == "false" {
        self.tmp = answerBox[str3]?.contains("false")
        if self.tmp == true { // これは間違ったことを示しているので、注意
        //if (answerBox[str3]?.contains("false"))! {
            cell.imgView.image = img2
        } else if self.tmp == nil {
            cell.imgView.image = img2
        } else {
            cell.imgView.image = img
    
        }
        
        //cell.imgView.image = answerBox
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultTableViewCell
        
        //let avViewController = self.storyboard?.instantiateViewController(withIdentifier:"AV") as! AVPlayerViewController
        //avViewController.postdata = self.postdata
        //self.navigationController?.pushViewController(avViewController, animated: true)
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170 //変更
    }
    */

    @IBAction func backButton(_ sender: Any) {

        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.answerBox = [:]
        self.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func streamButton(_ sender: Any) {
        guard let url = URL(string: self.streamurl!) else {
            return
        }
        
        myMoviePlayerView = MPMoviePlayerViewController(contentURL: url)
        
        self.present(myMoviePlayerView, animated: true, completion: nil)
    }
    
    @IBAction func downloadButton(_ sender: Any) {
        aLabel.text = "しばらくおまちください..."
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "myapp-background")
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        
        let moviename = postdata as! String + ".mov"
        let reference = storageRef.child(moviename)
        let documentDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let localURL = URL(fileURLWithPath: documentDirPath + "/" + moviename)
        _ = reference.write(toFile: localURL) { url, error in
            if error != nil {
                // Uh-oh, an error occurred!
                print("失敗")
                print(error.debugDescription)
            } else {
                // Local file URL for "images/island.jpg" is returned
                print("downloadできました")
                print(localURL)
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
                SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                SVProgressHUD.showSuccess(withStatus: "ダウンロード完了！")
                SVProgressHUD.dismiss(withDelay: 1)
                self.aLabel.text = ""
                //データベースに登録
                let regist = Database.database().reference().child("users_download").child((Auth.auth().currentUser?.uid)!).child(self.postdata as! String)
                regist.setValue(self.postdata as! String + ".mov")
                
                
            }
    }
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            // ダウンロード完了時の処理
            
            print("didFinishDownloading")
            
            do {
                if let data = NSData(contentsOf: location) {
                    
                    let fileExtension = location.pathExtension
                    let filePath = getSaveDirectory() + getIdFromDateTime() + "." + fileExtension
                    
                    print(filePath)
                    
                    try data.write(toFile: filePath, options: .atomic)
                    //HUDの処理
                    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
                    SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
                    SVProgressHUD.showSuccess(withStatus: "ダウンロード完了！")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            } catch let error as NSError {
                print("download error: \(error)")
            }
        }
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            // ダウンロード進行中の処理
            
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            // ダウンロードの進捗をログに表示
            print(String(format: "%.2f", progress * 100) + "%")
            
            // メインスレッドでプログレスバーの更新処理
            //DispatchQueue.main.async(execute: {
            //    self.progressBar.setProgress(progress, animated: true)
            //})
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            // ダウンロードエラー発生時の処理
            if error != nil {
                print("download error: \(String(describing: error))")
            }
        }
        func getIdFromDateTime() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            return dateFormatter.string(from: Date())
        }
        // 保存するディレクトリのパス
        func getSaveDirectory() -> String {
            
            let fileManager = Foundation.FileManager.default
            
            // ライブラリディレクトリのルートパスを取得して、それにフォルダ名を追加
            let path = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.libraryDirectory, Foundation.FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/DownloadFiles/"
            
            // ディレクトリがない場合は作る
            if !fileManager.fileExists(atPath: path) {
                createDir(path: path)
            }
            
           
            return path
        }
        func createDir(path: String) {
            do {
                let fileManager = Foundation.FileManager.default
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("createDir: \(error)")
            }
        }
        
    
    }
}
