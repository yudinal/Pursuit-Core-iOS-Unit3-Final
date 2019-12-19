//
//  Element.swift
//  Elements
//
//  Created by Lilia Yudina on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct Elements: Codable {
    let result: [Element]
}

struct Element: Codable {
    let id: String?
    let name: String?
    let appearance: String?
    let atomic_mass: Double?
    let boil: Double?
    let category: String?
    let color: String?
    let density: Double?
    let discovered_by: String?
    let melt: Double?
    let molar_heat: Double?
    let named_by: String?
    let number: Int
    let period: Int?
    let phase: String?
    let source: String?
    let spectral_img: String?
    let summary: String?
    let symbol: String
    let favoritedBy: String?
    
    func editedElementNumber(for element: Element) -> String {
        var number = element.number
        switch number{
        case 0...9:
            return "00\(number)"
        case 10...99:
            return "0\(number)"
        default:
            return "\(number)"
        }
    }
}

