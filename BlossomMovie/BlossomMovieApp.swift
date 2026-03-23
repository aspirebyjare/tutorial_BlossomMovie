//
//  BlossomMovieApp.swift
//  BlossomMovie
//
//  Created by Jared Smith on 3/21/26.
//

import SwiftUI
import SwiftData

@main
struct BlossomMovieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Title.self)
    }
}
