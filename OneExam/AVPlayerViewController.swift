//
//  AVPlayerViewController.swift
//  OneExam
//
//  Created by 鳥越洋之 on 2019/03/27.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerViewController: UIViewController {

    var player: AVPlayer!
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    @IBOutlet weak var avView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.avView.layer.borderColor = UIColor.black.cgColor
        self.avView.layer.borderWidth = 3
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
        // UIImage インスタンスの生成
        

    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        print("video")
        guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/oneexam-3d30f.appspot.com/o/BBA9CC28-B7E3-4B82-B2AF-062773E2C3FC.MOV?alt=media&token=2d1dcf10-b1e2-45d2-8f74-d4ed9cc8f9af") else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.avView.bounds
        
        self.avView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @IBAction func touchedStartDownloadButton(_ sender: UIButton) {
        //テキトーに動画ダウンロード
        let url = URL(string: "https://www.vidsplay.com/wp-content/uploads/2017/05/toyboat.mp4")
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if(data == nil){
                print("ダウンロード失敗")
                return
            }
            if data!.count == 0 {
                print("ダウンロード失敗？")
            } else {
                print("ダウンロード成功時")
                //ドキュメントフォルダのパス
                let path = NSSearchPathForDirectoriesInDomains(
                    .documentDirectory,
                    .userDomainMask, true).last!
                //ファイルのパス
                let _path = path + "/test.mp4"
                
                //アプリ内に保存
                ((try? data?.write(to: URL(fileURLWithPath: _path))) as ()??)
                print("ダウンロード終了")
            }
        }
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
