//
//  GenreViewCell.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 28/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

class GenreViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
