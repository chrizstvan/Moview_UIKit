//
//  MovieDetailViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 01/01/21.
//  Copyright © 2021 ADI Consulting Test. All rights reserved.
//

import UIKit

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
    
    var dataSource: UICollectionViewDiffableDataSource<Section<AnyHashable?, [AnyHashable]?>, AnyHashable>! = nil
    
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
        collectionView.delegate = self
        registerCell()
        
        configureDataSource()
        configureSupplementaryView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = pageTitle
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func registerCell() {
        collectionView.rigsterCellFromNib(cellIdentifer: "CLMovieOverviewCell")
        collectionView.rigsterCellFromNib(cellIdentifer: "CLTrailerCell")
        collectionView.rigsterCellFromNib(cellIdentifer: CLCommentCell.identifier)
        collectionView.register(
            HeaderView.nibName,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.reuseIdentifier
        )
        collectionView.register(
            FooterView.nibName,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterView.reuseIdentifier
        )
    }
}

extension MovieDetailViewController: MovieDetailViewProtocol {
    func populateMovieDetail(trailerVideos: [MovieVideo]?, reviews: [Review]?, movie: Movie?) {
        DispatchQueue.main.async {
            self.trailerVideos = trailerVideos
            self.reviews = reviews
            self.movie = movie
            
            self.refreshData()
        }
    }
    
    func showError(_ messages: String) {
        self.showErrorAlert(messages)
    }
}

//MARK: - Configure Layout
extension MovieDetailViewController {
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIdx, envLayot) -> NSCollectionLayoutSection? in
            let sectionIdentifier = self.dataSource.snapshot().sectionIdentifiers[sectionIdx].sectionItems
            
            if sectionIdentifier is [Movie] {
                return self.configOverviewSection()
            }
            
            if sectionIdentifier is [MovieVideo] {
                return self.configTrailerSection()
            }
            
            if sectionIdentifier is [Review] {
                return self.configReviewSection()
            }
            
            return nil
        }
    }
    
    private func configOverviewSection() -> NSCollectionLayoutSection? {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = [footer]
        return section
    }
    
    private func configTrailerSection() -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = [header, footer]
        return section
    }
    
    private func configReviewSection() -> NSCollectionLayoutSection? {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = [header, footer]
        return section
    }
}

//MARK: - Configure Datasource
extension MovieDetailViewController {
    private func configureSupplementaryView() {
        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: HeaderView.reuseIdentifier,
                        for: indexPath) as? HeaderView else { return UICollectionReusableView() }
                // configure header
                let sectionType = self.dataSource.snapshot().sectionIdentifiers[indexPath.section].headerItem!!
                headerView.configureHeader(sectionType: sectionType)
                return headerView
            default:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: UICollectionView.elementKindSectionFooter,
                        withReuseIdentifier: FooterView.reuseIdentifier,
                        for: indexPath) as? FooterView else { return UICollectionReusableView() }
                // configure footer
                return footerView
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section<AnyHashable?, [AnyHashable]?>, AnyHashable>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
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
            
            if let review = item as? Review {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CLCommentCell.identifier, for: indexPath) as? CLCommentCell
                cell?.review = review
                return cell
            }
            
            return nil
        })
    }
    
    func add(items: [Section<AnyHashable?, [AnyHashable]?>]) {
        let payloadDatasource = DataSource(sections: items)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section<AnyHashable?, [AnyHashable]?>, AnyHashable>()
        payloadDatasource.sections.forEach {
            if let items = $0.sectionItems {
                snapshot.appendSections([$0])
                snapshot.appendItems(items!)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func refreshData() {
        var sections: [Section<AnyHashable?, [AnyHashable]?>] = []
        
        guard let movie = self.movie, let trailers = trailerVideos else { return }
        sections.append(Section(headerItem: nil, sectionItems: [movie]))
        sections.append(Section(headerItem: TrailerSection(), sectionItems: trailers))
        sections.append(Section(headerItem: ReviewSection(), sectionItems: reviews ?? nil ))
        
        add(items: sections)
    }
}

// MARK: Select cell
extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = dataSource.snapshot().sectionIdentifiers[indexPath.section].sectionItems as? [MovieVideo] {
            presenter?.showYoutubeTrailer(pageTitle: pageTitle!, indexPath: indexPath)
        }
    }
}
