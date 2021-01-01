//
//  MovieDetailViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 01/01/21.
//  Copyright © 2021 ADI Consulting Test. All rights reserved.
//

import UIKit

enum SectionLayout: Hashable {
    case overview
    case trailer
}

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var id: Int?
    var pageTitle: String?
    var presenter: MovieDetailPresenterProtocol?
    
    var sectionNumber = Int()
    var totalTrailer = Int()
    var totalReviews = Int()
    var trailerVideos: [MovieVideo]?
    var reviews: [Review]?
    var movie: Movie?
    
    var dataSource: UICollectionViewDiffableDataSource<SectionLayout, Movie>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovie(id: id)
        setUpController()
    }
    
    private func getMovie(id: Int?) {
        guard let movieId = id else { return }
        presenter?.getMovie(id: movieId)
    }
    
    private func setUpController() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        registerCell()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = pageTitle
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func registerCell() {
        collectionView.rigsterCellFromNib(cellIdentifer: "CLMovieOverviewCell")
        collectionView.rigsterCellFromNib(cellIdentifer: "CLTrailerCell")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIdx, envLayot) -> NSCollectionLayoutSection? in
            let sectionIdentifier = self.dataSource.snapshot().sectionIdentifiers[sectionIdx]
            
            switch sectionIdentifier {
            case .overview:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)),
                    subitem: item,
                    count: 1
                )
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            case .trailer:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
        
    }
    
    private func configureDataSource(movie: Movie?) {
        dataSource = UICollectionViewDiffableDataSource<SectionLayout, Movie>(collectionView: collectionView) { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: movie) else {
                return nil
            }
            
            switch sectionIdentifier {
            case .overview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLMovieOverviewCell", for: indexPath) as! CLMovieOverviewCell
                cell.movie = movie
                return cell
            case .trailer:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLTrailerCell", for: indexPath) as! CLTrailerCell
                cell.movieVideo = movie.videos?.results[indexPath.item]
                return cell
            }
        }
        
        guard let movie = movie else { return }
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayout, Movie>()
        snapshot.appendSections([.overview, .trailer])
        snapshot.appendItems([movie])
        
        dataSource.apply(snapshot)
    }
}

extension MovieDetailViewController: MovieDetailViewProtocol {
    func populateMovieDetail(trailerVideos: [MovieVideo]?, reviews: [Review]?, movie: Movie?) {
        DispatchQueue.main.async {
            self.trailerVideos = trailerVideos
            self.reviews = reviews
            self.movie = movie
            
            self.configureDataSource(movie: movie)
        }
    }
    
    func showError(_ messages: String) {
        self.showErrorAlert(messages)
    }
}
