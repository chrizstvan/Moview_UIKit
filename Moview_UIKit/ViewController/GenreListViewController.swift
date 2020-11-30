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

    private var viewModel = GenreListViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        getDiscover(id: genreId)
    }
    
    private func getDiscover(id: Int?) {
        guard let genreId = id else { return }
        viewModel.getDiscover(id: "\(genreId)") {[weak self] error in
            if error != nil {
                // @todo: show error messages
                print(error!)
            }
            
            self?.collectionView.reloadData()
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
        viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterViewCell", for: indexPath) as! MoviePosterViewCell
        cell.movie = viewModel.movies[indexPath.item]
        
        return cell
    }
    
    
}

extension GenreListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = MovieDetailViewController.instantiate()
        destination.id = viewModel.movies[indexPath.item].id
        destination.pageTitle = viewModel.movies[indexPath.item].title
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: (collectionView.frame.size.width - 10) / 2 ,
            height: collectionView.frame.size.width * 0.7
        )
    }
}
