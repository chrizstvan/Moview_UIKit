//
//  DiscoverViewModel.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 30/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

class DiscoverViewModel {
    var genres = [Genre]()
    
    func getGenres(completion: @escaping (String?) -> Void) {
        MovieStore.shared.fetchGenres {[weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.genres = response.genres
                    completion(nil)
                }
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}