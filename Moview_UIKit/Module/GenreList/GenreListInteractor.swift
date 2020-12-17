//
//  GenreListInteractor.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 17/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

protocol GenreListInteractorProtocol {
    var presenter: GenreListOutputInteractorProtocol? { get set}
    func fetchMovies(id: String, page: Int)
}

final class GenreListInteractor: GenreListInteractorProtocol {
    weak var presenter: GenreListOutputInteractorProtocol?
    
    func fetchMovies(id: String, page: Int) {
        MovieStore.shared.fetchDiscover(
            genre: id,
            page: page
        ) {[weak self] result in
            switch result {
            case .success(let response):
                let currentPage = response.page
                let totalPage = response.totalPages
                self?.presenter?.showMovies(
                    movies: response.results,
                    page: currentPage,
                    totalPage: totalPage,
                    errorMsg: nil
                )
            case .failure(let error):
                self?.presenter?.showMovies(
                    movies: nil,
                    page: nil,
                    totalPage: 0,
                    errorMsg: error.localizedDescription
                )
            }
        }
    }
}
