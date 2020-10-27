//
//  CustomCellTableViewCell.swift
//  BankingApp
//
//  Created by Frank Novello on 9/11/20.
//  Copyright © 2020 Frank Novello. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {


    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
