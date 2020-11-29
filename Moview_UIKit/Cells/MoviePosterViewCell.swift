//
//  MoviePosterViewCell.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 29/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit
import SDWebImage

class MoviePosterViewCell: UICollectionViewCell {
    @IBOutlet weak var poster: UIImageView!
    
    var movie: Movie? {
        didSet {
            poster.sd_setImage(with: movie?.posterURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
