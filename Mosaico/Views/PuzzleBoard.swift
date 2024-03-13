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
    
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [GameStats]
    
    @State private var showingError = false
    @State private var error: LocalizedError? {
        didSet {
            showingError = (error != nil)
        }
    }

    var body: some View {
        ZStack {
            Color.mBlue
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Mosaico")
                    .font(AppFonts.helveticaNeue(ofSize: kTitleFontSize))
                    .foregroundColor(.white)
                    .padding(.top, kLargePadding)
                
                if viewModel.pieces.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.top, kLargePadding)
                } else {
                    LazyVGrid(columns: viewModel.layout, spacing: viewModel.gridSpacing) {
                        ForEach(viewModel.pieces) { piece in
                            PuzzleTile(piece: piece)
                                .onDrag {
                                    self.viewModel.pieceDragging = piece
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DragPieceDelegate(piece: piece, 
                                                                                 pieces: $viewModel.pieces,
                                                                                 current: $viewModel.pieceDragging))
                        }
                    }
                    .cornerRadius(kPuzzleBoardCornerRadius)
                }
                
                Spacer()
                
                if let stats = stats.first {
                    Text("Score \(stats.score)")
                        .font(AppFonts.helveticaNeue(ofSize: kMediumFontSize))
                        .foregroundColor(.white)
                }
                
                Button {
                    withAnimation {
                        viewModel.gridSpacing = 0
                    }
                } label: {
                    Text("finish")
                }
                .padding()
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


