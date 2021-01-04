//
//  HeaderView.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 05/01/21.
//  Copyright © 2021 ADI Consulting Test. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureHeader(sectionType: AnyHashable) {
        if let header = sectionType as? TrailerSection {
            titleLabel.text = header.title
        }
    
        if let header = sectionType as? ReviewSection {
            titleLabel.text = header.title
        }
    }
}


