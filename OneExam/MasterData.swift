//
//  MasterData.swift
//  OneExam
//
//  Created by 鳥越洋之 on 2019/03/21.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MasterData: NSObject {
    var id: String?
    var title: String!
    var content: String!
    var date: Date?
    var question: String!
    var template: String!
    var answer: String!
    var choices =  [[String:String]]()
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        
        print(snapshot.key)
        //let valueDictionary = snapshot.value as! [String: Any]
        dump(snapshot.value)
        
        
        let array = snapshot.value as! [Any]
        
        for item in array {
            
            if let valueDictionary = item as? [String: Any] {
                self.title = valueDictionary["title"] as? String
                self.content = valueDictionary["content"] as? String
                self.question = valueDictionary["question"] as? String
                self.template = valueDictionary["template"] as? String
                self.answer = valueDictionary["answer"] as? String
                if let choice = valueDictionary["choices"] as? [[String:String]] {
                    self.choices = choice
                }
            } else {
                continue
            }
        }
       
        
        
    }
}
