//
//  MovieDetailInteractor.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 17/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

protocol MovieDetailInteractorProtocol {
    var presnter: MovieDetailOutputInteractorProtocol? { get set }
    func fetchMovie(id: Int)
    func fetchReviews(id: Int, movie: Movie)
}

final class MovieDetailInteractor: MovieDetailInteractorProtocol {
    weak var presnter: MovieDetailOutputInteractorProtocol?
    
    func fetchMovie(id: Int) {
        MovieStore.shared.fetchMovie(id: id) {[weak self] result in
            switch result {
            case .success(let response):
                self?.fetchReviews(id: id, movie: response)
            case .failure(let error):
                self?.presnter?.showError(messages: error.localizedDescription)
            }
        }
    }
    
    func fetchReviews(id: Int, movie: Movie) {
        MovieStore.shared.fetchReviews(id: id) {[weak self] result in
            switch result {
            case .success(let response):
                let reviews = response.results
                self?.presnter?.showDetailMovie(movie: movie, reviews: reviews!)
            case .failure(let error):
                self?.presnter?.showError(messages: error.localizedDescription)
            }
        }
    }
    
    
}
