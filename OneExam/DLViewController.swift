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

        
    }
    override func viewWillAppear(_ animated: Bool) {
        // AVPlayerView のインスタンス化と画面への追加
        
        // 動画を読み込み、動画プレイヤーに設定
        print("video")
        // Bundle Resourcesからsample.mp4を読み込んで再生
        let documentDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let localURL = documentDirPath + "/hotel.mov"
        print(localURL)
        
        let player = AVPlayer(url: URL(fileURLWithPath: localURL))
        player.play()
        
        
        // AVPlayer用のLayerを生成
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1 // ボタン等よりも後ろに表示
        view.layer.insertSublayer(playerLayer, at: 0) // 動画をレイヤーとして追加
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
