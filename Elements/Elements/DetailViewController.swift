//
//  DetailViewController.swift
//  Elements
//
//  Created by Lilia Yudina on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var elementImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var elements: Element!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        numberLabel.text = elements.number.description
        symbolLabel.text = elements.symbol
        nameLabel.text = elements.name
        weightLabel.text = elements.atomic_mass?.description
        if let elementName = elements.name{
            elementImage.getImage(with: "https://images-of-elements.com/\(elementName.lowercased()).jpg") { [weak self] (result) in
                       switch result {
                       case .failure(let appError):
                        print(appError)
                           self?.elementImage.image = UIImage(systemName: "Person")
                       case .success(let image):
                           DispatchQueue.main.async {
                               self?.elementImage.image = image
                           }
                       }
                       
                   }
        }
       
        
    }
    
    
    @IBAction func favoriteButton(_ sender: UIButton) {
    
        let post = FavoriteElement(id: elements.id ?? "45", symbol: elements.symbol, discovered_by: elements.discovered_by ?? "", molar_heat: elements.molar_heat ?? 6.6, phase: elements.phase ?? "", source: elements.source ?? "", summary: elements.summary ?? "", favoritedBy: "Lilia Yudina", number: elements.number, appearance: elements.appearance ?? "", density: elements.density ?? 9.8, atomic_mass: elements.atomic_mass ?? 8, name: elements.name ?? "")
        
        ElementAPIClient.postElements(element: post) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error posting element", message: "\(appError)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success", message: "Element was posted")
                }
            }
        }
        
    }
    

    
    
}
