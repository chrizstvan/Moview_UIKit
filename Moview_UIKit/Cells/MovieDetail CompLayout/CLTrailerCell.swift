//
//  CLTrailerCell.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 01/01/21.
//  Copyright © 2021 ADI Consulting Test. All rights reserved.
//

import UIKit

class CLTrailerCell: UICollectionViewCell {
    @IBOutlet weak var movieTitle: UILabel!
    
    var movieVideo: MovieVideo? {
        didSet {
            guard let trailer = movieVideo else { return }
            movieTitle.text = trailer.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
