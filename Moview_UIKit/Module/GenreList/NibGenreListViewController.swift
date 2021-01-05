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
    
    enum GenreSection { case main }
    typealias DataSource = UICollectionViewDiffableDataSource<GenreSection, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<GenreSection, Movie>
    private lazy var dataSource = makeDataSource()
    
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
        collectionView.collectionViewLayout = configureLayout()
        registerCell()
        //collectionView.dataSource = self
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

// MARK: View delegate implementation
extension NibGenreListViewController: GenreListViewProtocol {
    func populateMovies(movies: [Movie]?, page: Int, errorMsg: String?) {
        guard errorMsg == nil else {
            self.showErrorAlert(errorMsg!)
            return
        }
        
        self.currentPage = page > self.currentPage ? page : self.currentPage
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
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
            //self.collectionView.reloadData()
            self.applySnapshot()
        }
    }
}

// MARK: Configure diffable datasoure
extension NibGenreListViewController {
    func makeDataSource() -> DataSource {
        DataSource(
            collectionView: collectionView
        ) { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MoviePosterViewCell",
                for: indexPath) as? MoviePosterViewCell
            cell?.movie = movie
            return cell
        }
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.movies)
        dataSource.apply(snapshot)
    }
}

//extension NibGenreListViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.movies.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterViewCell", for: indexPath) as! MoviePosterViewCell
//        cell.movie = movies[indexPath.item]
//
//        return cell
//    }
//}

// MARK: Configure compositional layout
extension NibGenreListViewController {
    func configureLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIdx, layoutEnv) -> NSCollectionLayoutSection? in
            return self.configureSection()
        }
    }
    
    func configureSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(2/3)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: Selection Setup
extension NibGenreListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dataSource.snapshot().itemIdentifiers[indexPath.row].id == movies[indexPath.row].id {
            presenter?.didSelectMovies(indexPath: indexPath, movies: self.movies)
        }
    }
}

// MARK: Pagination set up
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
