//
//  PuzzleBoard.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import SwiftUI
import SwiftData
import AlertToast
import UniformTypeIdentifiers

struct PuzzleBoard: View {
    
    @State var viewModel: PuzzleBoardViewModel
    @State private var imageDragging: UIImage?
    
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [GameStats]
    
    @State private var showingError = false
    @State private var error: LocalizedError? {
        didSet {
            showingError = (error != nil)
        }
    }

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                ForEach(viewModel.tileImages, id: \.self) { image in
                    PuzzleTile(image: Image(uiImage: image))
                        .onDrag {
                            self.imageDragging = image
                            return NSItemProvider(object: image)
                        }
                        .onDrop(of: [UTType.text], delegate: viewModel)
                }
            }
            
            if let stats = stats.first {
                Text("Score \(stats.score)")
            }
        }
        .task {
            if stats.isEmpty {
                createGameStats()
            }
            do {
                try await viewModel.fetchImage()
            } catch {
                self.error = error as? LocalizedError
            }
        }
        .toast(isPresenting: $showingError) {
            AlertToast(displayMode: .banner(.slide),
                       type: .error(.white),
                       title: error?.failureReason ?? "Action Failed",
                       style: .style(backgroundColor: Color.mRed,
                                     titleColor: .white,
                                     titleFont: AppFonts.helveticaNeue(ofSize: kMediumFontSize)))
        }
    }

    private func createGameStats() {
        withAnimation {
            let stats = GameStats()
            modelContext.insert(stats)
        }
    }
}

#Preview {
    PuzzleBoard(viewModel: PuzzleBoardViewModel(imageService: MockImageService()))
        .modelContainer(for: GameStats.self, inMemory: true)
}
