//
//  TopomapperApp.swift
//  Topomapper
//
//  Created by Derek Chai on 20/06/2024.
//

import SwiftUI
import SwiftData

@main
struct TopomapperApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Route.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
