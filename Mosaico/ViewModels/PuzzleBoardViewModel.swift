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
    
    var pieceDragging: PuzzlePiece?
    
    var gridSpacing = kGridSpacing
    var isComplete: Bool = false
    var pieces: [PuzzlePiece] = []
    
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
        do {
            let image = try await imageService.fetchImage(fromURL: url)
            splitImage(image)
        } catch {
            guard let image = UIImage(named: kDefaultImageName) else {
                throw error
            }
            splitImage(image)
            throw error
        }
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
        let shuffled = pieces.shuffled()
        withAnimation {
            /// Update the index of each piece to reflect it's current position in the array
            for (index, piece) in shuffled.enumerated() {
                piece.currentIndex = index
            }
            pieces = shuffled
        }
    }
    
    func splitImage(_ image: UIImage) {
        withAnimation {
            self.pieces = image.splitIntoPieces()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + kSecondsBeforeShuffle) {
            self.shuffle()
        }
    }
}
