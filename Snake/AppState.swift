//
//  AppState.swift
//  Snake
//
//  Created by Nick Pavlov on 6/14/23.
//

import Foundation

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var gameID = UUID()
}
