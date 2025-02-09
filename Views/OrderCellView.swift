//
//  OrderCellView.swift
//  HelloCoffeeApp
//
//  Created by Mohamed Shafai on 04/02/2025.
//

import SwiftUI

struct OrderCellView: View {
    let order : Order
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                Text(order.name).bold()
                Text(order.coffeeName).opacity(0.5)
            }
            
            Spacer()
            
            VStack{
                Text("EGP \(String(order.total))")
            }
        }
        
    }
}
