//
//  PuzzleBoardViewModel.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import UIKit
import SwiftUI

@Observable
class PuzzleBoardViewModel {
    
    var imageService: ImageServiceProtocol
    
    var image: UIImage?
    var pieceDragging: PuzzlePiece?
    
    var gridSpacing = kGridSpacing
    
    var isComplete: Bool = false
    var currentPieces: [PuzzlePiece] = []
    var originalPieces: [PuzzlePiece] = []
    
    var layout: [GridItem] {
        [
            GridItem(.flexible(minimum: kMinGridItemSize), spacing: gridSpacing),
            GridItem(.flexible(minimum: kMinGridItemSize), spacing: gridSpacing),
            GridItem(.flexible(minimum: kMinGridItemSize), spacing: gridSpacing),
        ]
    }
    
    // MARK: - Initializer
    
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    // MARK: - Public
    
    @MainActor
    func fetchImage() async throws {
        guard let url = Endpoint.largeImage.url else {
            throw ImageError.invalidURL
        }
        let image = try await imageService.fetchImage(fromURL: url)
        withAnimation {
            self.image = image
        }
        splitImage()
    }
    
    @MainActor
    func startOver() async throws {
        try await fetchImage()
        withAnimation {
            isComplete = false
            gridSpacing = kGridSpacing
        }
    }
    
    func shuffle() {
        let shuffled = originalPieces.shuffled()
        withAnimation {
            /// Updates the current index of each piece to the new shuffled indices and updates the current pieces
            currentPieces = shuffled.enumerated().map { (index, piece) in piece.setCurrentIndex(index) }
        }
    }
    
    func splitImage() {
        guard let image = self.image else {
            return
        }
        let pieces = image.splitIntoPieces()
        withAnimation {
            originalPieces = pieces
            currentPieces = pieces
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + kSecondsBeforeShuffle) {
            self.shuffle()
        }
    }
}
