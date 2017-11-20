//
//  MyTableViewCell.swift
//  HomeTownLocation
//
//  Created by Abhishek rane on 11/1/17.
//  Copyright © 2017 Abhishek rane. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var displayNick: UILabel!
    @IBOutlet weak var displayCountry: UILabel!
    @IBOutlet weak var displayState: UILabel!
    @IBOutlet weak var displayCity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
