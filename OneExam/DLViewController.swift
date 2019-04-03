//
//  DLViewController.swift
//  OneExam
//
//  Created by new torigoe on 2019/03/20.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Foundation
import  FirebaseStorage

class DLViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // AVPlayerView のインスタンス化と画面への追加
        
        // 動画を読み込み、動画プレイヤーに設定
        print("video")
       // let storage = Storage.storage()
       // let storageRef = storage.reference()
        
        
       // let documentDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // ドキュメントディレクトリの「パス」（String型）
        let documentDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        
        // ドキュメントディレクトリの「ファイルURL」（URL型）
        let documentDirFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        
        print(documentDirPath)
        print("--------------------")
        print(documentDirFileURL)

        
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let documentDirPath1 = URL(string: documentDirPath + "cook.mov")
        let player = AVPlayer(url: documentDirPath1!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.imageView.bounds
        
        self.imageView.layer.addSublayer(playerLayer)
        player.play()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func playVideo(_ sender: Any) {
        
    }
}
