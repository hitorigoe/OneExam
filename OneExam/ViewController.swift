//
//  ViewController.swift
//  OneExam
//
//  Created by new torigoe on 2019/03/15.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase // 先頭でFirebaseをimportしておく
import FirebaseAuth

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTab()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
    
    func setupTab() {
        
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "pie","download","settings"])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 0.7, green: 0.04, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor.gray
        tabBarController.selectionIndicatorHeight = 6
        
        // 作成したESTabBarControllerを親のViewController（＝self）に追加する
        addChild(tabBarController)
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            ])
        tabBarController.didMove(toParent: self)
        
        // タブをタップした時に表示するViewControllerを設定する
        let chartsViewController = storyboard?.instantiateViewController(withIdentifier: "Charts")
        let collectViewController = storyboard?.instantiateViewController(withIdentifier: "Collect")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        
        tabBarController.setView(chartsViewController, at: 1)
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(collectViewController, at: 2)
        tabBarController.setView(settingViewController, at: 3)
        

    }
}
