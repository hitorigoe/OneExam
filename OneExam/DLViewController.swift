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
import FirebaseStorage

class DLViewController: UIViewController {

    var documentDirPath :String!
    var localURL: String!
    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!
    //@IBOutlet weak var imageView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        // AVPlayerView のインスタンス化と画面への追加
        
        // 動画を読み込み、動画プレイヤーに設定
        print("video")

        // Bundle Resourcesからsample.mp4を読み込んで再生
        self.documentDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        self.localURL = documentDirPath + "/hotel.mov"
        
        self.player = AVPlayer(url: URL(fileURLWithPath: localURL))
        
        
        // AVPlayer用のLayerを生成
        self.playerLayer = AVPlayerLayer(player: player)
        view.frame = CGRect(x:0,y:100,width:self.view.bounds.width,height:300)
        self.playerLayer.frame = view.bounds
        
        self.playerLayer.videoGravity = .resizeAspect
        
        self.playerLayer.zPosition = -1 // ボタン等よりも後ろに表示
        view.layer.insertSublayer(self.playerLayer, at: 0) // 動画をレイヤーとして追加
    }
    



    @IBAction func playsvideo(_ sender: UIButton) {
        // Bundle Resourcesからsample.mp4を読み込んで再生


        print("shori")
        
        self.player.play()
    }
    
    @IBAction func pauseVideo(_ sender: Any) {
        // Bundle Resourcesからsample.mp4を読み込んで再生

        self.player.pause()
    }
    @IBAction func backButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
