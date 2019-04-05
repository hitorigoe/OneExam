//
//  ChartData.swift
//  OneExam
//
//  Created by new torigoe on 2019/04/05.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChartData: NSObject {
    var movie: String?
    
    init(snapshot: DataSnapshot) {
 
        //let valueDictionary = snapshot.value as! [String: Any]

        
        
        let array = snapshot.value as Any
        
        
            if let valueDictionary = array as? String {
                print("eee")
                dump(snapshot.value!)
                print("ddd")
                self.movie = valueDictionary

            }
    }
}

