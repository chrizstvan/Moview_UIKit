//
//  MovieDetailViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 01/01/21.
//  Copyright © 2021 ADI Consulting Test. All rights reserved.
//

import UIKit

enum SectionLayout: Hashable, CaseIterable {
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
    
    var dataSource: UICollectionViewDiffableDataSource<Section<AnyHashable?, [AnyHashable]>, AnyHashable>! = nil
    
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
        configureDataSource()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = pageTitle
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func registerCell() {
        collectionView.rigsterCellFromNib(cellIdentifer: "CLMovieOverviewCell")
        collectionView.rigsterCellFromNib(cellIdentifer: "CLTrailerCell")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIdx, envLayot) -> NSCollectionLayoutSection? in
            let sectionIdentifier = self.dataSource.snapshot().sectionIdentifiers[sectionIdx].headerItem!
            
            if sectionIdentifier is OverviewSection {
                return self.configOverviewSection()
            }
            
            if sectionIdentifier is TrailerSection {
                return self.configTrailerSection()
            }
            
            return nil
        }
    }
    
    private func configOverviewSection() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.75)),
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func configTrailerSection() -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    /*private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayout, Movie>(collectionView: collectionView) { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: movie) else {
                return nil
            }
            
            switch sectionIdentifier {
            case .overview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLMovieOverviewCell", for: indexPath) as? CLMovieOverviewCell
                cell?.movie = movie
                return cell
            case .trailer:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLTrailerCell", for: indexPath) as? CLTrailerCell
                //cell?.movieVideo = movie.videos?.results[indexPath.item]
                let movie = self.dataSource.snapshot().itemIdentifiers[indexPath.item]
                cell?.movieVideo = movie.videos?.results[indexPath.item]
                return cell
            }
        }
    }
    
    private func snapshotData() {
        guard let movie = self.movie else { return }
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayout, Movie>()
        snapshot.appendSections([.overview])
        snapshot.appendItems([movie])
        
        //snapshot.appendSections([.trailer])
        //snapshot.appendItems([movie])
        
        dataSource.apply(snapshot)
    }*/
}

extension MovieDetailViewController: MovieDetailViewProtocol {
    func populateMovieDetail(trailerVideos: [MovieVideo]?, reviews: [Review]?, movie: Movie?) {
        DispatchQueue.main.async {
            self.trailerVideos = trailerVideos
            self.reviews = reviews
            self.movie = movie
            
            //self.snapshotData()
            self.refreshData()
        }
    }
    
    func showError(_ messages: String) {
        self.showErrorAlert(messages)
    }
}

// configure datasource
extension MovieDetailViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section<AnyHashable?, [AnyHashable]>, AnyHashable>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            if let movie = item as? Movie {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLMovieOverviewCell", for: indexPath) as? CLMovieOverviewCell
                cell?.movie = movie
                return cell
            }
            
            if let trailer = item as? MovieVideo {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLTrailerCell", for: indexPath) as? CLTrailerCell
                cell?.movieVideo = trailer
                return cell
            }
            
            return nil
        })
    }
    
    func add(items: [Section<AnyHashable?, [AnyHashable]>]) {
            
        let payloadDatasource = DataSource(sections: items)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section<AnyHashable?, [AnyHashable]>, AnyHashable>()
        payloadDatasource.sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.sectionItems)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func refreshData() {
        
        var sections: [Section<AnyHashable?, [AnyHashable]>] = []
        
        
        guard let movie = self.movie, let trailers = trailerVideos else { return }
        sections.append(Section(headerItem: OverviewSection(movie: movie), sectionItems: [movie]))
        sections.append(Section(headerItem: TrailerSection(trailers: trailers), sectionItems: trailers))
        
        add(items: sections)
    }
}
