//
//  CLMovieOverviewCell.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 01/01/21.
//  Copyright © 2021 ADI Consulting Test. All rights reserved.
//

import UIKit
import SDWebImage

class CLMovieOverviewCell: UICollectionViewCell {
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var rateStarLabel: UILabel!
    @IBOutlet weak var rateNumberLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            backdropImage.sd_setImage(with: movie.backdropURL)
            genreLabel.text = movie.genreText + " • "
            yearLabel.text = movie.yearText + " • "
            durationLabel.text = movie.durationText
            overviewLabel.text = movie.overview
            rateStarLabel.text = movie.ratingText
            rateNumberLabel.text = movie.scoreText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
