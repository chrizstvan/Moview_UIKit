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
    
    var movie: Movie?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
    }

    private func setUpController() {
        tableView.rigsterCellFromNib(cellIdentifer: "MovieOverviewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        // set nav bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = movie?.title
        navigationItem.largeTitleDisplayMode = .automatic
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // case section 1
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOverviewCell", for: indexPath) as! MovieOverviewCell
        cell.movie = self.movie
        
        return cell
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

