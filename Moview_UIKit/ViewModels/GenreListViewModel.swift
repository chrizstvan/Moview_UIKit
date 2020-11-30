//
//  GenreListViewModel.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 30/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

class GenreListViewModel {
    var movies = [Movie]()
    
    func getDiscover(id: String, completion: @escaping(String?) -> Void) {
        MovieStore.shared.fetchDiscover(
        genre: id,
        page: 1
        ) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.movies = response.results
                    completion(nil)
                }
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
