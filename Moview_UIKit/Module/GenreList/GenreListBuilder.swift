//
//  GenreListBuilder.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 17/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

final class GenreListBuilder {
    var genre: Genre
    
    init(genre: Genre) {
        self.genre = genre
    }
    
    func build() -> UIViewController {
        let view = NibGenreListViewController()
        let presenter = GenreListPresenter()
        let interactor = GenreListInteractor()
        let router = GenreListRouter()
        
        view.genreId = genre.id
        view.pageTitle = genre.name
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        interactor.presenter = presenter
        
        return view
    }
}
