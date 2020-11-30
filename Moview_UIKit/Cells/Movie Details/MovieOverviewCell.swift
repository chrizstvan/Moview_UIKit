//
//  MovieOverviewCell.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 29/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit
import SDWebImage

class MovieOverviewCell: UITableViewCell {
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingNumLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            backdrop.sd_setImage(with: movie.backdropURL)
            genreLabel.text = movie.genreText + " • "
            yearLabel.text = movie.yearText
            durationLabel.text = movie.durationText
            overviewLabel.text = movie.overview
            ratingLabel.text = movie.ratingText
            ratingNumLabel.text = movie.scoreText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
