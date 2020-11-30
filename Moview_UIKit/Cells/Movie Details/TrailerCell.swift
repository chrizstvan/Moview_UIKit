//
//  TrailerCell.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 30/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

class TrailerCell: UITableViewCell {
    
    @IBOutlet weak var trailerTitle: UILabel!
    
    var movieVideo: MovieVideo? {
        didSet {
            guard let trailer = movieVideo else { return }
            trailerTitle.text = trailer.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
