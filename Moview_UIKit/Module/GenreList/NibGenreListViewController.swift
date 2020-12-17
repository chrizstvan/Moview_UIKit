//
//  NibGenreListViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 16/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

protocol GenreListViewProtocol: class {
    var presenter: GenreListPresenterProtocol? { get set }
    func populateMovies(movies: [Movie]?, page: Int, errorMsg: String?)
}

class NibGenreListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageTitle: String?
    var genreId: Int?
    private var currentPage = 1
    private var paginating = false
    
    var movies = [Movie]()
    var presenter: GenreListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        getDiscover(id: genreId, isPaginating: paginating)
    }
    
    private func getDiscover(id: Int?, isPaginating: Bool) {
        guard isPaginating, let genreId = id else { return }
        presenter?.getMovies(id: genreId, page: currentPage)
    }
    
    private func setUpController() {
        registerCell()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // set nav bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = pageTitle
        navigationItem.largeTitleDisplayMode = .automatic
        
        paginating = true
    }
    
    private func registerCell() {
        collectionView.rigsterCellFromNib(cellIdentifer: "MoviePosterViewCell")
    }
}

extension NibGenreListViewController: GenreListViewProtocol {
    func populateMovies(movies: [Movie]?, page: Int, errorMsg: String?) {
        guard errorMsg == nil else {
            self.showErrorAlert(errorMsg!)
            return
        }
        
        self.currentPage = page > self.currentPage ? page : self.currentPage
        
        DispatchQueue.main.async {
            if self.currentPage > 1 {
                if let movieArray = movies {
                    movieArray.forEach { movie in
                        self.movies.append(movie)
                    }
                }
            } else {
                self.movies = movies!
            }
            
            self.paginating = false
            self.collectionView.reloadData()
        }
    }
}

extension NibGenreListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterViewCell", for: indexPath) as! MoviePosterViewCell
        cell.movie = movies[indexPath.item]
        
        return cell
    }
}

extension NibGenreListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectMovies(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: (collectionView.frame.size.width - 10) / 2 ,
            height: collectionView.frame.size.width * 0.7
        )
    }
}

extension NibGenreListViewController: UIScrollViewDelegate {
    private func hasScrlolledEnoughTriggerPaggination(paginationOffset: CGFloat) -> Bool {
        let scrollHeight = collectionView.contentSize.height
        let currenScrollOffset = collectionView.contentOffset.y
        let viewHeight = collectionView.frame.size.height
        return currenScrollOffset > 0 && scrollHeight - currenScrollOffset < paginationOffset * viewHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else {
            return
        }
        
        if  hasScrlolledEnoughTriggerPaggination(paginationOffset: 3) {
            paginating = true
        }
        
        if hasScrlolledEnoughTriggerPaggination(paginationOffset: 2) && paginating {
            getDiscover(id: genreId!, isPaginating: paginating)
        }
    }
}
