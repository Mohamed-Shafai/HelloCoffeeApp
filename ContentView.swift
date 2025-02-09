//
//  ContentView.swift
//  HelloCoffeeApp
//
//  Created by Mohamed Shafai on 03/02/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var model: AppModel
    @State private var isPresented: Bool = false
    
    private func populate() async {
        do {
            try await model.populateOrders()
        } catch {
            print(error)
        }
    }
    
    private func delete(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let order = model.orders[index]
            guard let orderId = order.id else {
                return
            }

            Task {
                do {
                    try await model.deleteOrder(orderId)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                if model.orders.isEmpty{
                    Text("No Orders Available")
                } else {
                    List{
                        ForEach(model.orders){ order in
                            NavigationLink(value: order.id){
                                OrderCellView(order: order)
                            }
                        }.onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Orders")
            .navigationDestination(for: Int.self) { orderId in
                OrderDetailView(orderId: orderId)
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add New Order"){
                        isPresented = true
                    }
                }
            }
            .task{
                await populate()
            }
            .sheet(isPresented: $isPresented, content: {
                AddOrderView()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppModel(webservice: Webservice(baseURL: URL(string: "https://island-bramble.glitch.me/test/orders")!)))
    }
}
