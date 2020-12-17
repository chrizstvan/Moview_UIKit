//
//  GenreListPresenter.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 17/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

protocol GenreListPresenterProtocol {
    var interactor: GenreListInteractorProtocol? { get set }
    var router: GenreListRouterProtocol? { get set }
    func getMovies(id: Int, page: Int)
    func didSelectMovies(indexPath: IndexPath, movies: [Movie])
}

protocol GenreListOutputInteractorProtocol: class {
    var view: GenreListViewProtocol? { get set }
    func showMovies(movies: [Movie]?, page: Int?, totalPage: Int, errorMsg: String?)
}

final class GenreListPresenter: GenreListPresenterProtocol, GenreListOutputInteractorProtocol {
    var interactor: GenreListInteractorProtocol?
    var router: GenreListRouterProtocol?
    weak var view: GenreListViewProtocol?
    
    private var moviesResult: [Movie]?
    private let pageConstant = 1
    
    func getMovies(id: Int, page: Int) {
        interactor?.fetchMovies(id: "\(id)", page: page)
    }
    
    func showMovies(movies: [Movie]?, page: Int?, totalPage: Int, errorMsg: String?) {
        guard totalPage != page else { return }
        moviesResult?.removeAll()
        moviesResult = movies
        
        let currentPage = page! + pageConstant
        view?.populateMovies(movies: moviesResult, page: currentPage, errorMsg: errorMsg)
    }
    
    func didSelectMovies(indexPath: IndexPath, movies: [Movie]) {
        let movie = movies[indexPath.item]
        router?.routeToMovieDetail(view: view!, movie: movie)
    }
}
