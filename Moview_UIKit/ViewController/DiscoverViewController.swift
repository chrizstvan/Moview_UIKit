//
//  DiscoverViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 28/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, Storyboarded {
    
    private var genres: [Genre] = []
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //loadDiscover()
        setUpController()
        getGenres()
        
    }
    
    func getGenres() {
        MovieStore.shared.fetchGenres { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.genres = response.genres
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setUpController() {
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
        
        // set nav bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Moview"
        navigationItem.largeTitleDisplayMode = .automatic
    }

    private func registerCell() {
        tableView.rigsterCellFromNib(cellIdentifer: "GenreViewCell")
    }
}

extension DiscoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreViewCell", for: indexPath) as! GenreViewCell
        cell.title.text = genres[indexPath.row].name
        cell.subtitle.text = "\(genres[indexPath.row].id)"
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

extension DiscoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = GenreListViewController.instantiate()
        destination.pageTitle = genres[indexPath.row].name
        destination.genreId = genres[indexPath.row].id
        navigationController?.pushViewController(destination, animated: true)
        
    }
}
