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
    var title: String?
    var content: String?
    var date: Date?
    var link: String?
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        self.title = valueDictionary["title"] as? String
        self.content = valueDictionary["content"] as? String
        self.link = valueDictionary["link"] as? String
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
    }
}
