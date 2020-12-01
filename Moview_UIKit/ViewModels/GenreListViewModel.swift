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
    
    private func isPagination(page: Int, totalPages: Int) -> Bool {
        page > 1 && page < totalPages
    }
    
    func getDiscover(id: String, page: Int?, completion: @escaping(String?) -> Void) {
        MovieStore.shared.fetchDiscover(
        genre: id,
        page: page
        ) { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
                DispatchQueue.main.async {
                    if (self?.isPagination(page: page!, totalPages: response.totalPages))! {
                        self?.movies.append(contentsOf: response.results)
                    } else {
                        self?.movies = response.results
                    }
                    
                    completion(nil)
                }
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
