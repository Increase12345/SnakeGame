//
//  SnakeApp.swift
//  Snake
//
//  Created by Nick Pavlov on 6/13/23.
//

import SwiftUI

@main
struct SnakeApp: App {
    @StateObject var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .id(appState.gameID)
        }
    }
}
