//
//  ReviewCell.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 30/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var content: UILabel!
    
    var review: Review? {
        didSet {
            guard let review = review else { return }
            //self.avatar.sd_setImage(with: URL(string: review.authorDetails.avatarPath ?? "")!)
            self.username.text = review.authorDetails.username
            self.content.text = review.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
