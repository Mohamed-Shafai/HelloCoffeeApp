//
//  OderDetailView.swift
//  HelloCoffeeApp
//
//  Created by Mohamed Shafai on 04/02/2025.
//

import SwiftUI

struct OrderDetailView: View {
    
    let orderId: Int
    @EnvironmentObject private var model: AppModel
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented: Bool = false

    
    private var order: Order? {
        model.getOrderByOrderId(by: orderId)
    }
    
    private func deleteOrder() async {
        do {
            try await model.deleteOrder(orderId)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        VStack(alignment:.leading, spacing: 10){
            if let order = order {
                Text(order.coffeeName).font(.title).frame(maxWidth: .infinity, alignment: .leading)
                Text(order.size.rawValue).font(.callout).opacity(0.5)
                Text("EGP \(order.total, specifier: "%.2f")")
            }
            
            
            HStack {
                Spacer()
                Button("Delete Order", role: .destructive){
                    Task {
                        await deleteOrder()
                    }
                }
                Button("Edit Order"){
                    isPresented = true
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $isPresented, content: {
            if let order = order {
                AddOrderView(order: order)
            }
        })
    }
}
