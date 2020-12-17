//
//  DiscoverInteractor.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 16/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

protocol DiscoverInputInteractorProtocol {
    var presnter: DiscoverOutputInteractorProtocol? { get set }
    func fetchGenres()
}

final class DiscoverInteractor: DiscoverInputInteractorProtocol {
    weak var presnter: DiscoverOutputInteractorProtocol?
    
    func fetchGenres() {
        MovieStore.shared.fetchGenres {[weak self] result in
            switch result {
            case .success(let response):
                self?.presnter?.showGenres(genres: response.genres, errorMessages: nil)
            case .failure(let error):
                self?.presnter?.showGenres(genres: nil, errorMessages: error.localizedDescription)
            }
        }
    }
    
    
}
