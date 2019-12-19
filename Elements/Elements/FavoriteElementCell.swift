//
//  FavoriteElementCell.swift
//  Elements
//
//  Created by Lilia Yudina on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class FavoriteElementCell: UITableViewCell {

    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteNameLabel: UILabel!
    @IBOutlet weak var favoriteDetailsLabel: UILabel!
    
    func configureFavoriteCell(for favoriteElement: Element) {
        favoriteNameLabel.text = favoriteElement.name
        favoriteDetailsLabel.text = ("\(favoriteElement.symbol.capitalized) (\(favoriteElement.number.description))  \(favoriteElement.atomic_mass!.description)")
        
        let urlString = "https://www.theodoregray.com/periodictable/Tiles/\(favoriteElement.editedElementNumber(for: favoriteElement))/s7.JPG"

        
        favoriteImage.getImage(with: urlString) { [weak self] (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.favoriteImage.image = image
                }
                    case .failure(let error):
                    print("Error: \(error)")
                }
        }
        
    }
    
}
