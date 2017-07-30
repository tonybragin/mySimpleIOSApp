//
//  itemCell.swift
//  testFocusStart
//
//  Created by TONY on 24/07/2017.
//  Copyright © 2017 TONY COMPANY. All rights reserved.
//

import UIKit

class itemCell: UITableViewCell {
    
    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemText: UILabel!
    @IBOutlet weak var itemImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemImg.isHidden = true
        itemText.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
