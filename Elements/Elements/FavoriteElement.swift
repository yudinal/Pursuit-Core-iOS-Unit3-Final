//
//  FavoriteElement.swift
//  Elements
//
//  Created by Lilia Yudina on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct FavoriteElement: Codable {
    let id: String
    let symbol: String
    let discovered_by: String
    let molar_heat: Double
    let phase: String
    let source: String
    let summary: String
    let favoritedBy: String
    let number: Int
    let appearance: String
    let density: Double
    let atomic_mass: Double
    let name: String
}
