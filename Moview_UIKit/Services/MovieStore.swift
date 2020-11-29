//
//  MovieStore.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 28/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

class MovieStore: MovieService {
    static let shared = MovieStore()
    private init() {}
    
    // https://www.themoviedb.org/settings/api
    private let apiKey = "7448f541702ff4aa0fb6fe401c2f14f4"
    private let baseURL = "https://api.themoviedb.org/3"
    private let session = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    func fetchMovies(from endpoint: MovieListEndPoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(url: url, completion: completion)
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(
            url: url,
            params: ["append_to_response": "videos, credits"],
            completion: completion
        )
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(
            url: url,
            params: [
                "language": "en-US",
                "include_adult": "false",
                "region": "US",
                "query": query
            ],
            completion: completion
        )
    }
    
    func fetchDiscover(genre: String?, page: Int?, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/discover/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(
            url: url,
            params: [
                "language": "en-US",
                "include_adult": false,
                "include_video": true,
                "page": page as Any,
                "with_genres": genre as Any
            ],
            completion: completion
        )
    }
    
    func fetchGenres(completion: @escaping (Result<GenreResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/genre/movie/list") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(
            url: url,
            params: ["language": "en-US"],
            completion: completion
        )
    }
    
    // Helper Method
    private func loadUrlAndDecode<D: Decodable>(
        url: URL,
        params: [String:Any]? = nil,
        completion: @escaping (Result<D, MovieError>) -> ()) {
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map {URLQueryItem(name: $0.key, value: $0.value as? String)})
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        session.dataTask(with: finalURL) {[weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodeResponse = try  self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodeResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
            
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(
        with result: Result<D, MovieError>,
        completion: @escaping (Result<D, MovieError>) -> ()
    ) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
