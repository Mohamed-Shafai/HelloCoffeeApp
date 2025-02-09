//
//  AppModel.swift
//  HelloCoffeeApp
//
//  Created by Mohamed Shafai on 04/02/2025.
//

import Foundation

@MainActor
class AppModel: ObservableObject {
    let webservice : Webservice
    @Published private(set) var orders: [Order] = []
    
    init(webservice: Webservice) {
        self.webservice = webservice
    }
    
    func populateOrders() async throws {
        orders = try await webservice.get_orders()
    }
    
    func postOrder(_ order: Order) async throws {
        let newOrder = try await webservice.post_order(order: order)
        orders.append(newOrder)
    }
    
    func deleteOrder(_ orderId: Int) async throws {
        let deletedOrder = try await webservice.delete_order(orderId)
        orders = orders.filter { $0.id != deletedOrder.id }
    }
    
    func getOrderByOrderId(by id: Int) -> Order? {
        return orders.first { $0.id == id }
    }
    
    func updateOrder(_ updatedOrder: Order) async throws {
        _ = try await webservice.update_order(updatedOrder)
        if let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) {
            orders[index] = updatedOrder
        }
    }
}
