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
    
    /// Error handling
    @State private var showingError = false
    @State private var error: LocalizedError? {
        didSet {
            showingError = (error != nil)
        }
    }
    
    /// Swift Data
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [GameStats]
    
    /// Size class
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        ZStack {
            Color.mDarkBlue.edgesIgnoringSafeArea(.all)
            /// If the size class is compact, show the puzzle in a horizontal layout
            if verticalSizeClass == .compact {
                HStack {
                    VStack(spacing: 0) {
                        Text(kMosaicoTitle)
                            .font(AppFonts.optima(ofSize: kTitleFontSize))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top)
                        Text(kPuzzleDirections)
                            .font(AppFonts.avenirNext(ofSize: kMediumFontSize))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        HStack {
                            NewGameButton
                            Spacer()
                        }
                        .padding(.vertical)
                        
                        if let stats = stats.first {
                            Text("\(kCompletedPuzzlesTitlePrompt) \(stats.score)")
                                .font(AppFonts.avenirNext(ofSize: kMediumFontSize))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if viewModel.isComplete {
                            Text(kCompletedPuzzleMessage)
                                .font(AppFonts.avenirNext(ofSize: kMediumFontSize))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)
                        }
                    }
                    .padding()
                    
                    VStack(spacing: 0) {
                        if viewModel.pieces.isEmpty {
                            Progress
                        } else {
                            Grid
                                .padding()
                        }
                    }
                }
            } else {    /// If the size class is regular, show the puzzle in a vertical layout
                VStack(spacing: 0) {
                    Text(kMosaicoTitle)
                        .font(AppFonts.optima(ofSize: kTitleFontSize))
                        .foregroundColor(.white)
                        .padding(.vertical)
                    
                    Text(kPuzzleDirections)
                        .font(AppFonts.avenirNext(ofSize: kMediumFontSize))
                        .foregroundColor(.white)
                    
                    if viewModel.pieces.isEmpty {
                        Progress
                    } else {
                        Grid
                            .padding()
                    }
                    
                    if viewModel.isComplete {
                        Text(kCompletedPuzzleMessage)
                            .font(AppFonts.avenirNext(ofSize: kMediumFontSize))
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                    
                    Spacer()
                    NewGameButton
                    
                    if let stats = stats.first {
                        Text("\(kCompletedPuzzlesTitlePrompt) \(stats.score)")
                            .font(AppFonts.avenirNext(ofSize: kMediumFontSize))
                            .foregroundColor(.white)
                            .padding(.top)
                    }
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
    
    private var Grid: some View {
        LazyVGrid(columns: viewModel.layout, spacing: viewModel.gridSpacing) {
            ForEach(viewModel.pieces) { piece in
                PuzzleTile(piece: piece)
                    .onDrag {
                        self.viewModel.pieceDragging = piece
                        return NSItemProvider()
                    }
                    .onDrop(of: [.text], delegate: DragPieceDelegate(originalPiece: piece,
                                                                     pieces: $viewModel.pieces,
                                                                     gridSpacing: $viewModel.gridSpacing,
                                                                     isComplete: $viewModel.isComplete,
                                                                     currentPiece: $viewModel.pieceDragging))
            }
        }
        .background(.white)
        .cornerRadius(kDefaultCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: kDefaultCornerRadius)
                .stroke(.white, lineWidth: kGridSpacing)
        )
    }
    
    private var Progress: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                Spacer()
            }
            Spacer()
        }
    }
    
    private var NewGameButton: some View {
        Button(kNewGameButtonTitle) {
            Task {
                do {
                    try await viewModel.startOver()
                } catch {
                    self.error = error as? LocalizedError
                }
            }
        }
        .buttonStyle(VibrantButtonStyle())
        .accessibilityIdentifier(kNewGameButtonAccessabilityLabel)
    }
}

#Preview {
    PuzzleBoard(viewModel: PuzzleBoardViewModel(imageService: MockImageService()))
        .modelContainer(for: GameStats.self, inMemory: true)
}

struct Landscape_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleBoard(viewModel: PuzzleBoardViewModel(imageService: MockImageService()))
            .previewInterfaceOrientation(.landscapeRight)
            .modelContainer(for: GameStats.self, inMemory: true)
    }
}


