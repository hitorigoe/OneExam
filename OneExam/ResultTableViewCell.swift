//
//  ResultTableViewCell.swift
//  OneExam
//
//  Created by 鳥越洋之 on 2019/03/25.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    var img : UIImage!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img = UIImage(named:"verified")
        imgView.image = img
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
