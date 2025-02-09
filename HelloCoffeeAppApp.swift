//
//  HelloCoffeeAppApp.swift
//  HelloCoffeeApp
//
//  Created by Mohamed Shafai on 03/02/2025.
//

import SwiftUI

@main
struct HelloCoffeeAppApp: App {
    
    @StateObject private var model: AppModel
    
    init() {
        let webservice = Webservice(baseURL: URL(string: "https://island-bramble.glitch.me")!)
        _model = StateObject(wrappedValue: AppModel(webservice: webservice))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
}
