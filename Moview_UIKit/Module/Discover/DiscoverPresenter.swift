//
//  DiscoverPresenter.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 16/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

protocol DiscoverPresenterProtocol: class {
    func getGenres()
}

protocol DiscoverOutputInteractorProtocol: class {
    func showGenres(genres: [Genre]?, errorMessages: String?)
}

final class DiscoverPresenter: DiscoverPresenterProtocol, DiscoverOutputInteractorProtocol {
    var interactor: DiscoverInputInteractorProtocol?
    weak var view: DiscoverViewProtocol?
    
    func getGenres() {
        interactor?.fetchGenres()
    }
    
    func showGenres(genres: [Genre]?, errorMessages: String?) {
        view?.showGenres(genres: genres, errorMessages: errorMessages)
    }
    
    
}
