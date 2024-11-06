//
//  swift_solid_carnivalApp.swift
//  swift-solid-carnival
//
//  Created by m1_air on 10/31/24.
//

import SwiftUI
import SwiftData

@main
struct swift_solid_carnivalApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            LoginUserView()
        }
        .modelContainer(sharedModelContainer)
    }
}
