//
//  MovieDetailViewModel.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 30/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

class MovieDetailViewModel {
    var movie: Movie?
    var reviews: [Review]?
    
    var isTrailerAvailable: Bool {
        movie?.youtubeTrailers != nil && (movie?.youtubeTrailers!.count)! > 0
    }
    
    var totalTrailer: Int {
        movie?.youtubeTrailers?.count ?? 0
    }
    
    var trailerVideos: [MovieVideo]? {
        movie?.videos?.results ?? nil
    }
    
    var isReviewsAvailable: Bool {
        reviews != nil && (reviews!.count) > 0
    }
    
    var totalReviews: Int {
        reviews?.count ?? 0
    }
    
    func getMovie(id: Int, completion: @escaping(String?) -> Void) {
        MovieStore.shared.fetchMovie(id: id) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.movie = response
                    self?.getReviews(id: id, completion: completion)
                }
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    private func getReviews(id: Int, completion: @escaping(String?) -> Void) {
        MovieStore.shared.fetchReviews(id: id) {[weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.reviews = response.results
                    print("reviews: \(response)")
                    completion(nil)
                }
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
