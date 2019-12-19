//
//  ElementCell.swift
//  Elements
//
//  Created by Lilia Yudina on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class ElementCell: UITableViewCell {

    @IBOutlet weak var elementImage: UIImageView!
    @IBOutlet weak var elementName: UILabel!
    @IBOutlet weak var elementDetailsLabel: UILabel!
    
    func configureCell(for element: Element) {
        elementName.text = element.name
        elementDetailsLabel.text = ("\(element.symbol.capitalized) (\(element.number.description))  \(element.atomic_mass!.description)")
        
        let urlString = "https://www.theodoregray.com/periodictable/Tiles/\(element.editedElementNumber(for: element))/s7.JPG"
        
        elementImage.getImage(with: urlString) { [weak self] (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.elementImage.image = image
                }
                    case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }

