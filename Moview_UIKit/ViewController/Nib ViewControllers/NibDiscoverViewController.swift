//
//  NibDiscoverViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 16/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

protocol DiscoverViewProtocol: class {
    func showGenres(genres: [Genre]?, errorMessages: String?)
}

class NibDiscoverViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = DiscoverViewModel()
    private var genres = [Genre]()
    var presenter: DiscoverPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        getGenres()
    }
    
    private func getGenres() {
        presenter?.getGenres()
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

extension NibDiscoverViewController: DiscoverViewProtocol {
    func showGenres(genres: [Genre]?, errorMessages: String?) {
        guard errorMessages == nil else {
            //show alert
            return
        }
    
        DispatchQueue.main.async {
            self.genres = genres!
            self.tableView.reloadData()
        }
    }
}

extension NibDiscoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return genres.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreViewCell", for: indexPath) as! GenreViewCell
        cell.title.text = genres[indexPath.row].name
        cell.selectionStyle = .none
        
        return cell
    }
}

extension NibDiscoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = NibGenreListViewController()
        destination.pageTitle = viewModel.genres[indexPath.row].name
        destination.genreId = viewModel.genres[indexPath.row].id
        navigationController?.pushViewController(destination, animated: true)
        
    }
}
