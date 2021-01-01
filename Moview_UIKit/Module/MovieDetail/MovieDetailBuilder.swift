//
//  MovieDetailBuilder.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 17/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

final class MovieDetailBuilder {
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func build() -> UIViewController {
        let view = MovieDetailViewController() //NibMovieDetailViewController()
        let presnter = MovieDetailPresnter()
        let interactor = MovieDetailInteractor()
        let router = MovieDetailRouter()
        
        view.id = movie.id
        view.pageTitle = movie.title
        view.presenter = presnter
        presnter.interactor = interactor
        presnter.router = router
        presnter.view = view
        interactor.presnter = presnter
        
        return view
    }
}
