//
//  MasterTableViewCell.swift
//  OneExam
//
//  Created by new torigoe on 2019/03/21.
//  Copyright © 2019 new torigoe. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    var img : UIImage!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var examButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img = UIImage(named:"china")
        imgView.image = img
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMasterData(_ masterData: MasterData) {
        print("setMasterDataにきた")
        self.titleLabel.text = "\(masterData.title!) "
        self.contentLabel.text = "\(masterData.content!) "
        //self.linkLabel.text = "\(masterData.link!) "
        //let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd"
        //let dateString = formatter.string(from: "\(masterData.id!) ")
        self.dateLabel.text = "\(masterData.id!) "
        
    }
    
}
