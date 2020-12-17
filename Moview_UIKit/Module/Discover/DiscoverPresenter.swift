//
//  DiscoverPresenter.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 16/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

protocol DiscoverPresenterProtocol: class {
    var interactor: DiscoverInputInteractorProtocol? { get set }
    var router: DiscoverRouterProtocol? { get set }
    func getGenres()
    func didSelectGenere(indexPath: IndexPath)
}

protocol DiscoverOutputInteractorProtocol: class {
    var view: DiscoverViewProtocol? { get set }
    func showGenres(genres: [Genre]?, errorMessages: String?)
}

final class DiscoverPresenter: DiscoverPresenterProtocol, DiscoverOutputInteractorProtocol {
    var interactor: DiscoverInputInteractorProtocol?
    var router: DiscoverRouterProtocol?
    weak var view: DiscoverViewProtocol?
    
    private var genreResult: [Genre]?
    
    func getGenres() {
        interactor?.fetchGenres()
    }
    
    func showGenres(genres: [Genre]?, errorMessages: String?) {
        genreResult = genres
        view?.showGenres(genres: genreResult, errorMessages: errorMessages)
    }
    
    func didSelectGenere(indexPath: IndexPath) {
        guard let genres = genreResult else { return }
        let genre = genres[indexPath.row]
        router?.routeToGenreList(view: view!, genre: genre)
    }
}
