//
//  Order.swift
//  HelloCoffeeApp
//
//  Created by Mohamed Shafai on 04/02/2025.
//

import Foundation

enum CoffeeSize: String, Codable , CaseIterable{
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
}

struct Order: Codable, Identifiable, Hashable {
    
    var id: Int?
    var name: String
    var coffeeName: String
    var total: Double
    var size: CoffeeSize
    
}

