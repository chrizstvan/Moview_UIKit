//
//  GenreListViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 29/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

class GenreListViewController: UIViewController, Storyboarded {
    var pageTitle: String?
    var genreId: Int?

    private var movies: [Movie] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        getDiscover(id: genreId)
    }
    
    private func getDiscover(id: Int?) {
        guard let genreId = id else { return }
        MovieStore.shared.fetchDiscover(genre: "\(genreId)", page: 1) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.movies = response.results
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setUpController() {
        registerCell()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // set nav bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = pageTitle
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func registerCell() {
        collectionView.rigsterCellFromNib(cellIdentifer: "MoviePosterViewCell")
    }
}

extension GenreListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterViewCell", for: indexPath) as! MoviePosterViewCell
        cell.movie = movies[indexPath.item]
        
        return cell
    }
    
    
}

extension GenreListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: (collectionView.frame.size.width - 10) / 2 ,
            height: collectionView.frame.size.width * 0.7
        )
    }
}
