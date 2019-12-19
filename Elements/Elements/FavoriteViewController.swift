//
//  FavoriteViewController.swift
//  Elements
//
//  Created by Lilia Yudina on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
      private var refreshControl: UIRefreshControl!
    var favoriteElements = [Element]() {
        didSet {
            DispatchQueue.main.async {
                self.favoriteTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
configureRefreshControl()
        loadElements()
    }
    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        favoriteTableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(loadElements), for: .valueChanged)
    }

    @objc

    private func loadElements() {
        ElementAPIClient.getElement { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "\(appError)")
                }
            case .success(let elements):
                self?.favoriteElements = elements
            }
        }
    }


}
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteElements.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteElementCell else {
            fatalError("Couldn't dequeue a FavoriteCell")
        }
        let favoriteElement = favoriteElements[indexPath.row]
        cell.configureFavoriteCell(for: favoriteElement)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailVC = storyboard.instantiateViewController(identifier: "elemVC") as? DetailViewController else {return}
            let element = favoriteElements[indexPath.row]
            detailVC.elements = element
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

