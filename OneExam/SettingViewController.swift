//
//  SettingViewController.swift
//  OneExam
//
//  Created by new torigoe on 2019/03/21.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    var image1: UIImage!

    @IBOutlet weak var settingBtn: UIButton!
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
            
            // 表示名が入力されていない時はHUDを出して何もしない
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                return
            }
            
            // 表示名を設定する
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    
                    // HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    @IBAction func handleLogoutButton(_ sender: Any) {
        // ログアウトする
        if Auth.auth().currentUser != nil {
            try! Auth.auth().signOut()
            // ログイン画面を表示する
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        
            // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
            let tabBarController = parent as! ESTabBarController
            tabBarController.setSelectedIndex(0, animated: false)
        } else {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier:"Login") as! LoginViewController
            
            self.present(loginViewController, animated: true, completion: nil)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        image1 = UIImage(named:"chinese_")
        imageView.image = image1
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
        //    displayNameTextField.text = user.displayName
            settingBtn.setTitle("ログアウト", for: .normal)
        } else {
            settingBtn.setTitle("会員登録する", for: .normal)
        }
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
