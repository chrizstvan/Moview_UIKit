//
//  NibMovieDetailViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 16/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

protocol MovieDetailViewProtocol: class {
    var sectionNumber: Int { get set }
    var totalTrailer: Int { get set }
    var totalReviews: Int { get set }
    var presenter: MovieDetailPresenterProtocol? { get set }
    func populateMovieDetail(trailerVideos: [MovieVideo]?, reviews: [Review]?, movie: Movie?)
    func showError(_ messages: String)
}

class NibMovieDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var id: Int?
    var pageTitle: String?
    var presenter: MovieDetailPresenterProtocol?
    
    var sectionNumber = Int()
    var totalTrailer = Int()
    var totalReviews = Int()
    var trailerVideos: [MovieVideo]?
    var reviews: [Review]?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovie(id: id)
        setUpController()
        registerCell()
    }

    private func getMovie(id: Int?) {
        guard let movieId = id else { return }
        presenter?.getMovie(id: movieId)
    }
    
    private func setUpController() {
        registerCell()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        // set nav bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = pageTitle
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func registerCell() {
        tableView.rigsterCellFromNib(cellIdentifer: "MovieOverviewCell")
        tableView.rigsterCellFromNib(cellIdentifer: "TrailerCell")
        tableView.rigsterCellFromNib(cellIdentifer: "ReviewCell")
    }
}

extension NibMovieDetailViewController: MovieDetailViewProtocol {
    func showError(_ messages: String) {
        self.showErrorAlert(messages)
    }
    
    func populateMovieDetail(trailerVideos: [MovieVideo]?, reviews: [Review]?, movie: Movie?) {
        DispatchQueue.main.async {
            self.trailerVideos = trailerVideos
            self.reviews = reviews
            self.movie = movie
            self.tableView.reloadData()
        }
    }
}

extension NibMovieDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNumber
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return totalTrailer
        } else if section == 2 {
            return totalReviews
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath) as! TrailerCell
            cell.movieVideo = trailerVideos?[indexPath.row]
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            cell.review = reviews?[indexPath.row]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOverviewCell", for: indexPath) as! MovieOverviewCell
        cell.movie = self.movie
        
        return cell
    }
}

extension NibMovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            presenter?.showYoutubeTrailer(pageTitle: pageTitle!, indexPath: indexPath)
        }
    }
}
