//
//  MovieDetailPresenter.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 17/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

protocol MovieDetailPresenterProtocol {
    var interactor: MovieDetailInteractorProtocol? { get set }
    var router: MovieDetailRouterProtocol? { get set }
    func getMovie(id: Int)
    func showYoutubeTrailer(pageTitle: String, indexPath: IndexPath)
}

protocol MovieDetailOutputInteractorProtocol: class {
    var view: MovieDetailViewProtocol? { get set }
    func showDetailMovie(movie: Movie, reviews: [Review])
    func showError(messages: String)
}

final class MovieDetailPresnter: MovieDetailPresenterProtocol, MovieDetailOutputInteractorProtocol {
    var interactor: MovieDetailInteractorProtocol?
    var router: MovieDetailRouterProtocol?
    weak var view: MovieDetailViewProtocol?
    
    private var movieResult: Movie?
    private var reviewsResult: [Review]?
    
    private var isTrailerAvailable: Bool {
        movieResult?.youtubeTrailers != nil && (movieResult?.youtubeTrailers!.count)! > 0
    }
    
    private var totalTrailer: Int {
        movieResult?.youtubeTrailers?.count ?? 0
    }
    
    private var trailerVideos: [MovieVideo]? {
        movieResult?.videos?.results ?? nil
    }
    
    private var isReviewsAvailable: Bool {
        reviewsResult != nil && (reviewsResult!.count) > 0
    }
    
    private var totalReviews: Int {
        reviewsResult?.count ?? 0
    }
    
    private var numberOfSection: Int {
        if isTrailerAvailable && isReviewsAvailable {
            return 3
        } else if isTrailerAvailable && !isReviewsAvailable {
            return 2
        } else if !isTrailerAvailable && isReviewsAvailable {
            return 2
        }
        
        return 1
    }
    
    func getMovie(id: Int) {
        interactor?.fetchMovie(id: id)
    }
    
    func showDetailMovie(movie: Movie, reviews: [Review]) {
        self.movieResult = movie
        self.reviewsResult = reviews
        view?.sectionNumber = self.numberOfSection
        view?.totalTrailer = self.totalTrailer
        view?.totalReviews = self.totalReviews
        view?.populateMovieDetail(trailerVideos: self.trailerVideos, reviews: self.reviewsResult, movie: self.movieResult)
    }
    
    func showError(messages: String) {
        view?.showError(messages)
    }
    
    func showYoutubeTrailer(pageTitle: String, indexPath: IndexPath) {
        guard let movie = movieResult, let url = movie.youtubeTrailers?[indexPath.row].youtubeURL else { return }
        router?.showYoutubeTrailer(view: view!, pageTitle: pageTitle, url: url)
    }
}
