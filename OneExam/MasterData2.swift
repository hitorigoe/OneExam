//
//  MasterData2.swift
//  OneExam
//
//  Created by 鳥越洋之 on 2019/03/21.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MasterData2: NSObject {
    var id: String?
    var title: String!
    var content: String!
    var date: Date?
    var question: String!
    var template: String!
    var answer: String!
    var choices =  [[String:String]]()
    var button1 : String!
    var button2 : String!
    var button3 : String!
    var button4 : String!
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        
        
        //let valueDictionary = snapshot.value as! [String: Any]
        
        print("zzz")
        
        
        //let array = snapshot.value as! [Any]
        let snapshotDic = snapshot.value as! [String: Any]
        self.title = snapshotDic["title"] as? String
        self.content = snapshotDic["content"] as? String
        self.template = snapshotDic["template"] as? String
        self.question = snapshotDic["question"] as? String
        self.answer = snapshotDic["answer"] as? String
        let choices = snapshotDic["choices"] as! [String : Any]
        self.button1 = choices["a"] as? String
        self.button2 = choices["b"] as? String
        self.button3 = choices["c"] as? String
        self.button4 = choices["d"] as? String
        
        
        /*
        for item in array {
            let valueDictionary = item as! [String: Any]
            self.title = valueDictionary["title"] as? String
            self.content = valueDictionary["content"] as? String
            self.question = valueDictionary["question"] as? String
            self.template = valueDictionary["template"] as? String
            self.answer = valueDictionary["answer"] as? String
            //self.choices = valueDictionary["choices"] as! [String : Any]
            if let choice = valueDictionary["choices"] as? [[String:String]] {
                self.choices = choice
            }
        }
        */
        print("xxx")
        
        
        
    }
}
