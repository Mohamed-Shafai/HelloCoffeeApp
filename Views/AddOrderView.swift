//
//  AddOrderView.swift
//  HelloCoffeeApp
//
//  Created by Mohamed Shafai on 05/02/2025.
//

import SwiftUI

struct AddCoffeeErrors {
    var name: String = ""
    var coffeeName: String = ""
    var price: String = ""
}

struct AddOrderView: View {
    
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var total: String = ""
    @State private var coffeeSize: CoffeeSize = .medium
    
    @State private var errors: AddCoffeeErrors = AddCoffeeErrors()
    
    var order: Order?
    
    init(order: Order? = nil){
        self.order = order
        if let order = order {
            _name = State(initialValue: order.name)
            _coffeeName = State(initialValue: order.coffeeName)
            _coffeeSize = State(initialValue: order.size)
            _total = State(initialValue: "\(order.total)")
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: AppModel
    
    var isValid: Bool {
        errors = AddCoffeeErrors()
        
        if name.isEmpty {
            errors.name = "name cannot be empty"
        }
        if coffeeName.isEmpty {
            errors.coffeeName = "coffee name cannot be empty"
        }
        if total.isEmpty {
            errors.price = "price cannot be empty"
        } else if Double(total) == nil {
            errors.price = "price need to be a number"
        } else if let price = Double(total), price < 0 {
            errors.price = "price need to be bigger than 0"
        }
        
        return errors.name.isEmpty && errors.coffeeName.isEmpty && errors.price.isEmpty
    }
    
    
    func placeOrder() async {
        if let order = order {
            let updatedOrder = Order(id: order.id, name: name, coffeeName: coffeeName, total: Double(total) ?? 0.0, size: coffeeSize)
            do {
                try await model.updateOrder(updatedOrder)
                dismiss()
            } catch {
                print(error)
            }
        }
        else {
            let newOrder = Order(name: name, coffeeName: coffeeName, total: Double(total) ?? 0.0, size: coffeeSize)
            
            do {
                try await model.postOrder(newOrder)
                dismiss()
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            Form {
                
                TextField("Name", text: $name)
                if !(errors.name.isEmpty) {
                    Text(errors.name).font(.caption)
                }
                
                TextField("Coffee name", text: $coffeeName)
                if !(errors.coffeeName.isEmpty) {
                    Text(errors.coffeeName).font(.caption)
                }
                
                TextField("Price", text: $total)
                if !(errors.price.isEmpty) {
                    Text(errors.price).font(.caption)
                }
                
                Picker("Select size", selection: $coffeeSize, content: {
                    ForEach(CoffeeSize.allCases, id: \.rawValue){ size in
                        Text(size.rawValue).tag(size)
                    }
                }).pickerStyle(.segmented)
                
                HStack {
                    Spacer()
                    Button("Save Order"){
                        if isValid {
                            Task {
                                await placeOrder()
                            }
                        }
                    }
                    Spacer()
                }

            }
            .navigationTitle(order == nil ? "Add Order" : "Edit Order")
        }
    }
}

#Preview {
    AddOrderView()
}
