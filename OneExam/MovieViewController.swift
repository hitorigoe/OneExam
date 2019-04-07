//
//  MovieViewController.swift
//  OneExam
//
//  Created by 鳥越洋之 on 2019/04/07.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import MediaPlayer
import FirebaseStorage
import Firebase


class MovieViewController: UIViewController {
    
// MPMoviePlayerViewControllerの宣言.
var myMoviePlayerView : MPMoviePlayerViewController!
    var moviedata:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ボタンの生成.
        //let myButton = UIButton()
        //myButton.frame.size = CGSize(width: 100, height: 40)
        //myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        //myButton.layer.masksToBounds = true
        //myButton.layer.cornerRadius = 20.0
        //myButton.backgroundColor = UIColor.orange
        //myButton.setTitle("動画再生", for: .normal)
        //myButton.setTitleColor(UIColor.white, for: .normal)
        //myButton.setTitleShadowColor(UIColor.gray, for: .normal)
        //myButton.addTarget(self, action: "onClickMyButton:", for: .touchUpInside)
        
        //self.view.addSubview(myButton)
        
    }
    
    
    @IBAction func onclickMyButton(_ sender: Any) {
        print("aaa")
        dump(sender)
        print("bbb")
        //var myMoviePath = NSURL.fileURL(withPath: Bundle.main.path(forResource: "20190320", ofType: "mov")!)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "myapp-background")
        //let session = URLSession(configuration: sessionConfig, delegate: self as! URLSessionDelegate, delegateQueue: nil)
        
        
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
    
    // 動画の再生が終了した時に呼ばれるメソッド.
    func moviePlayBackDidFinish(notification: NSNotification) {
        print("moviePlayBackDidFinish:")
        // 通知があったらnotificationを削除.
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil)
    }
}
