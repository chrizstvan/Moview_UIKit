//
//  NibGenreListViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 16/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

class NibGenreListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageTitle: String?
    var genreId: Int?
    private var currentPage = 1
    private var paginating = false
    private var viewModel = GenreListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        getDiscover(id: genreId, isPaginating: paginating)
    }

    private func getDiscover(id: Int?, isPaginating: Bool) {
        guard isPaginating, let genreId = id else { return }
        print("current page: \(currentPage)")
        viewModel.getDiscover(id: "\(genreId)", page: currentPage) {[weak self] error in
            if error != nil {
                // @todo: show error messages
                print(error!)
            }
            self?.currentPage += 1
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
        
        paginating = true
    }
    
    private func registerCell() {
        collectionView.rigsterCellFromNib(cellIdentifer: "MoviePosterViewCell")
    }
}

extension NibGenreListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterViewCell", for: indexPath) as! MoviePosterViewCell
        cell.movie = viewModel.movies[indexPath.item]
        
        return cell
    }
}

extension NibGenreListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = NibMovieDetailViewController()
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
        
        if hasScrlolledEnoughTriggerPaggination(paginationOffset: 2) {
            getDiscover(id: genreId, isPaginating: paginating)
            paginating = false
        }
    }
}
