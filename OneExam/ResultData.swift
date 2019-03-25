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
    var question: String!
    var answer: String!
    
    init(snapshot: DataSnapshot) {
        
        print(snapshot.key)
        print("resultデータに処理がきた")
        //let valueDictionary = snapshot.value as! [String: Any]
        dump(snapshot.value)
        
        
        let array = snapshot.value as! [Any]
        
        for item in array {
            let valueDictionary = item as! [String: Any]
            self.question = valueDictionary["question"] as? String
            self.answer = valueDictionary["answer"] as? String
        }
    }
}
