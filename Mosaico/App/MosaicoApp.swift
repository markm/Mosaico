//
//  MosaicoApp.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import SwiftUI
import SwiftData

@main
struct MosaicoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GameStats.self,
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
            PuzzleBoard(viewModel: PuzzleBoardViewModel(imageService: ImageService()))
        }
        .modelContainer(sharedModelContainer)
    }
}
