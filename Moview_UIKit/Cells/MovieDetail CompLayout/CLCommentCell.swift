//
//  CLCommentCell.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 05/01/21.
//  Copyright © 2021 ADI Consulting Test. All rights reserved.
//

import UIKit

class CLCommentCell: UICollectionViewCell {
    static let identifier = "CLCommentCell"
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var review: Review? {
        didSet {
            guard let review = review else { return }
            self.usernameLabel.text = review.authorDetails.username
            self.commentLabel.text = review.content
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
