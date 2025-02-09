//
//  Webservice.swift
//  HelloCoffeeApp
//
//  Created by Mohamed Shafai on 04/02/2025.
//
// Webservice is the calling of the servers through the web

import Foundation

enum NetworkError: Error{
    case badURL
    case badRequest
    case DecodingError
    case idError
}

enum EndPoint {
    
    case allOrders
    
    var path: String {
        switch self {
        case .allOrders:
            return "https://island-bramble.glitch.me/test/orders"
        }
    }
}

class Webservice {
    
    private var baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // we gonna need get_orders - place_order - delete_order - update_order
    
    
    //update order
    func update_order(_ order: Order) async throws -> Order {
        
        guard let orderId = order.id else {
            throw NetworkError.idError
        }
        
        guard let url = URL(string: "https://island-bramble.glitch.me/test/orders/\(orderId)")
        else {
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let updatedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.DecodingError
        }
                
        return updatedOrder
    }
    
    //delete_order to remove the desired order
    func delete_order(_ orderId: Int) async throws -> Order {
        guard let url = URL(string: "https://island-bramble.glitch.me/test/orders/\(orderId)")
        else {
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let deletedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.DecodingError
        }
                
        return deletedOrder
    }
    
    //post_order to add the new order
    func post_order(order : Order) async throws -> Order {
        guard let url = URL(string: "https://island-bramble.glitch.me/test/new-order")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let newOrders = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.DecodingError
        }
                
        return newOrders
    }
    
    //get_orders to display in the screen
    func get_orders() async throws -> [Order] {
        
        guard let url = URL(string: "https://island-bramble.glitch.me/test/orders")
        else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        var orders :[Order] = []
        do {
            orders = try JSONDecoder().decode([Order].self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: \(context)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type mismatch for type \(type): \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(type, context) {
            print("Value not found for type \(type): \(context.debugDescription)")
        } catch {
            print("Decoding error: \(error)")
        }
        
        return orders
    }
    
}
