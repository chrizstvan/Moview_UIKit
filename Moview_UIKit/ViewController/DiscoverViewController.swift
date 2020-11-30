//
//  DiscoverViewController.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 28/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, Storyboarded {
    private var viewModel = DiscoverViewModel()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpController()
        getGenres()
    }
    
    private func getGenres() {
        viewModel.getGenres {[weak self] error in
            if error != nil {
                // @todo: show alert error messages
                print(error!)
            }
            
            self?.tableView.reloadData()
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
        return viewModel.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreViewCell", for: indexPath) as! GenreViewCell
        cell.title.text = viewModel.genres[indexPath.row].name
        cell.subtitle.text = "\(viewModel.genres[indexPath.row].id)"
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
        destination.pageTitle = viewModel.genres[indexPath.row].name
        destination.genreId = viewModel.genres[indexPath.row].id
        navigationController?.pushViewController(destination, animated: true)
        
    }
}
