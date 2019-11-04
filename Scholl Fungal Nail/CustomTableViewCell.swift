//
//  CustomTableViewCell.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 04/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSubTitle: UILabel!
    @IBOutlet weak var cellDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
