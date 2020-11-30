//
//  MovieDetailViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 29/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!
    
    var id: Int?
    var pageTitle: String?
    private var viewModel = MovieDetailViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        getMovie(id: id)
    }

    private func getMovie(id: Int?) {
        guard let movieId = id else { return }
        viewModel.getMovie(id: movieId) {[weak self] error in
            if error != nil {
                // @todo: show error messages
                print(error!)
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func setUpController() {
        registerCell()
        tableView.dataSource = self
        tableView.delegate = self
        
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

extension MovieDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.isTrailerAvailable && viewModel.isReviewsAvailable {
            return 3
        } else if viewModel.isReviewsAvailable && !viewModel.isTrailerAvailable {
            return 2
        } else if viewModel.isTrailerAvailable && !viewModel.isReviewsAvailable {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return viewModel.totalTrailer
        } else if section == 2 {
            return viewModel.totalReviews
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath) as! TrailerCell
            cell.movieVideo = viewModel.trailerVideos?[indexPath.row]
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            cell.review = viewModel.reviews?[indexPath.row]
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOverviewCell", for: indexPath) as! MovieOverviewCell
        cell.movie = self.viewModel.movie
        
        return cell
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let url = viewModel.movie?.youtubeTrailers?[indexPath.row].youtubeURL else { return }
            let destination = WebViewController(url: url, title: pageTitle!)
            let navVC = UINavigationController(rootViewController: destination)
            present(navVC, animated: true)
        }
    }
}

