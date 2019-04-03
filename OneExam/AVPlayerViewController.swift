//
//  AVPlayerViewController.swift
//  OneExam
//
//  Created by 鳥越洋之 on 2019/03/27.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import Firebase
import FirebaseAuth
import FirebaseStorage


class AVPlayerViewController: UIViewController, URLSessionDownloadDelegate {
    
    
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    var player: AVPlayer!
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    //var progressBar: UIProgressView!
    @IBOutlet weak var avView: UIView!
    var label:UILabel!
    var label2:UILabel!
    var progressView:UIProgressView!
    var progress:Float = 0.0
    var timer:Timer!
    var restartButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.avView.layer.borderColor = UIColor.black.cgColor
        self.avView.layer.borderWidth = 3
        
        /// ラベル
        
        /*
        label = UILabel(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.width - 20,height:20))
        var labelCenterPos = view.center
        labelCenterPos.y = labelCenterPos.y + 30
        label.center = labelCenterPos
        label.text = "しばらくお待ちください ..."
        label.textAlignment = .center
        view.addSubview(label)
        label2 = UILabel(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.width - 20,height:20))
        var labelCenterPos2 = view.center
        labelCenterPos2.y = labelCenterPos2.y + 50
        label2.center = labelCenterPos2
        label2.text = "DLコレクションにて視聴できます。"
        label2.textAlignment = .center
        view.addSubview(label2)
        
        /// プログレスバー
        progressView = UIProgressView(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.width - 60,height:20))
        progressView.center = view.center
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 6.0)
        progressView.progressTintColor = .blue
        progressView.setProgress(progress, animated: true)
        view.addSubview(progressView)
        */
        /// タイマー
        //timer = Timer.scheduledTimer(timeInterval: 0.01,
        //                             target: self,
        //                             selector: #selector(self.timerUpdate),
        //                             userInfo: nil,
        //                             repeats: true)
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
        DispatchQueue.main.async(execute: {
            self.progressBar.setProgress(progress, animated: true)
        })
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // ダウンロードエラー発生時の処理
        if error != nil {
            print("download error: \(String(describing: error))")
        }
    }
    // バックグラウンドで動作する非同期通信
    func startDownloadTask() {
        
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "myapp-background")
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        let url = URL(string: "gs://oneexam-3d30f.appspot.com")!
        
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // 現在時刻からユニークな文字列を得る
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
    
    // ディレクトリを作成
    func createDir(path: String) {
        do {
            let fileManager = Foundation.FileManager.default
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("createDir: \(error)")
        }
    }


    @objc func restart(_ s:UIButton) {
        
        timer.invalidate()
        progress = 0
        label.text = "please wait ..."
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(self.timerUpdate),
                                     userInfo: nil,
                                     repeats: true)
        
        // リセット時にアニメーションしたくないときはコメントアウトを解除
        //progressView.setProgress(progress, animated: false)
    }
    @objc func timerUpdate() {
        progress = progress + 0.001
        if progress < 1.1 {  // 浮動小数点誤差のため、<= 1.0 だとtrueにならないことがある
            progressView.setProgress(progress, animated: true)
        } else {
            timer.invalidate()
            label.text = "Complete !"
        }
    }

    
    @IBAction func playVideo(_ sender: UIButton) {
        print("video")
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        
        let documentDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let localURL = URL(fileURLWithPath: documentDirPath + "/hotel.mov")


        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: localURL)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.avView.bounds
        
        self.avView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @IBAction func touchedStartDownloadButton(_ sender: UIButton) {
        //startDownloadTask()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        
        let reference = storageRef.child("hotel.mov")
        let documentDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let localURL = URL(fileURLWithPath: documentDirPath + "/hotel.mov")
        _ = reference.write(toFile: localURL) { url, error in
            if error != nil {
                // Uh-oh, an error occurred!
                print("失敗")
                print(error.debugDescription)
            } else {
                // Local file URL for "images/island.jpg" is returned
                print("downloadできました")
                print(localURL)
            }
        }
        
        /*
        child.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
            } else {
                // ダウンロード先のURLを作成
                let localURL: URL! = URL(fileURLWithPath: "\(NSTemporaryDirectory())cook.mov")
                
                // ダウンロードを実行
                reference.write(toFile: localURL) { url, error in
                    if (error != nil) {
                        print("Uh-oh, an error occurred!")
                    } else {
                        print("download success!!")
                    }
                }
            }
        }
        */
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func homeButton(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.answerBox = [:]
        
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

}
