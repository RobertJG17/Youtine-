//
//  Youtine_App.swift
//  Youtine!
//
//  Created by Bobby Guerra on 2/19/26.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct Youtine_App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Routine.self,
            Habit.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        try? Tips.configure()
        Tips.showAllTipsForTesting()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
