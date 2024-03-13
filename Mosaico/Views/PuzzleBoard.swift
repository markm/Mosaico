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
            Color.mDarkBlue.edgesIgnoringSafeArea(.all)
            VStack {
                Text(kMosaicoTitle)
                    .font(AppFonts.optima(ofSize: kTitleFontSize))
                    .foregroundColor(.white)
                    .padding(.top, kLargePadding)
                
                Text("arrange the tiles to complete the puzzle")
                    .font(AppFonts.avenirNext(ofSize: kMediumFontSize))
                    .foregroundColor(.white)
                
                if viewModel.currentPieces.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.top, kLargePadding)
                } else {
                    LazyVGrid(columns: viewModel.layout, spacing: viewModel.gridSpacing) {
                        ForEach(viewModel.currentPieces) { piece in
                            PuzzleTile(piece: piece)
                                .onDrag {
                                    self.viewModel.pieceDragging = piece
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DragPieceDelegate(originalPiece: piece,
                                                                                 pieces: $viewModel.currentPieces,
                                                                                 gridSpacing: $viewModel.gridSpacing,
                                                                                 isComplete: $viewModel.isComplete,
                                                                                 currentPiece: $viewModel.pieceDragging))
                        }
                    }
                    .background(.white)
                    .cornerRadius(kDefaultCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: kDefaultCornerRadius)
                            .stroke(.white, lineWidth: 2)
                    )
                    .padding()
                }
                
                if viewModel.isComplete {
                    Text("Puzzle Complete!")
                        .font(AppFonts.avenirNext(ofSize: kMediumFontSize))
                        .foregroundColor(.white)
                        .padding(.top)
                }
                
                Spacer()
                
                Button(kNewGameButtonTitle) {
                    viewModel.startOver()
                }
                .buttonStyle(VibrantButtonStyle())
                
                if let stats = stats.first {
                    Text("Completed Puzzles: \(stats.score)")
                        .font(AppFonts.avenirNext(ofSize: kMediumFontSize))
                        .foregroundColor(.white)
                        .padding(.top)
                }
            }
        }
        .task {
            do {
                try await viewModel.fetchImage()
            } catch {
                self.error = error as? LocalizedError
            }
        }
        .onAppear {
            if stats.isEmpty {
                createGameStats()
            }
        }
        .onChange(of: viewModel.isComplete, { oldValue, newValue in
            if newValue {
                withAnimation {
                    stats.first?.score += 1
                }
            }
        })
        .toast(isPresenting: $showingError) {
            AlertToast(displayMode: .banner(.slide),
                       type: .error(.white),
                       title: error?.failureReason ?? "Action Failed",
                       style: .style(backgroundColor: Color.mRed,
                                     titleColor: .white,
                                     titleFont: AppFonts.avenirNext(ofSize: kMediumFontSize)))
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


