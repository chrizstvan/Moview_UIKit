//
//  GenreListRouter.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 17/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

protocol GenreListRouterProtocol {
    func routeToMovieDetail(view: GenreListViewProtocol, movie: Movie)
}

final class GenreListRouter: GenreListRouterProtocol {
    func routeToMovieDetail(view: GenreListViewProtocol, movie: Movie) {
        if let superVC = view as? UIViewController {
            let vc = MovieDetailBuilder(movie: movie).build()
            superVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
