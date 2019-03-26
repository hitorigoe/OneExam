//
//  ResultData.swift
//  OneExam
//
//  Created by new torigoe on 2019/03/25.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ResultData: NSObject {
    var ref: DatabaseReference?
    var question: String?
    var answer: String?
    var correct: String?
    var choices: [String:Any]?
    init?(snapshot: DataSnapshot) {
        print("ショリショリ")
        dump(snapshot.value )
        let valueDictionary = snapshot.value as! [String:Any]
        print("resultデータに処理がきた")

            dump(valueDictionary["choices"]!)
        self.question = valueDictionary["question"]! as? String
        self.correct = valueDictionary["answer"]! as? String
        choices = valueDictionary["choices"]! as? [String:Any]
        for item in choices! {
            print(item.key)
            if item.key == correct {
                self.answer = item.value as? String
            }
        }
        /*
        for item in array {
            let valueDictionary = item as! [String: Any]
            self.question = valueDictionary["question"] as? String
            self.answer = valueDictionary["answer"] as? String
        }
        */
    }
}
