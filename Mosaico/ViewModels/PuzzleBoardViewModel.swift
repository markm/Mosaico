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
    
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    func fetchImage() async throws {
        guard let url = Endpoint.largeImage.url else {
            throw ImageError.invalidURL
        }
        do {
            self.image = try await imageService.fetchImage(fromURL: url)
            self.splitImage(into: 3)
        } catch {
            throw ImageError.failedToLoadImage
        }
    }
    
    func shuffle() {
        let shuffled = originalPieces.shuffled()
        withAnimation {
            /// Updates the current index of each piece to the new shuffled indices and updates the current pieces
            currentPieces = shuffled.enumerated().map { (index, piece) in piece.setCurrentIndex(index) }
        }
    }
    
    @MainActor
    func startOver() {
        Task {
            do {
                try? await fetchImage()
                withAnimation {
                    isComplete = false
                }
            }
        }
    }
    
    private func splitImage(into gridSize: Int) {
        guard let image = self.image else {
            return
        }
        let size = CGSize(width: image.size.width / CGFloat(gridSize), height: image.size.height / CGFloat(gridSize))
        var images: [UIImage] = []
        for y in 0..<gridSize {
            for x in 0..<gridSize {
                UIGraphicsBeginImageContext(size)
                image.draw(at: CGPoint(x: -CGFloat(x) * size.width, y: -CGFloat(y) * size.height))
                let tileImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if let tileImage = tileImage {
                    images.append(tileImage)
                }
            }
        }
        let pieces = images.enumerated().map { (index, image) in PuzzlePiece(image: image, index: index) }
        withAnimation {
            originalPieces = pieces
            currentPieces = pieces
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + kSecondsBeforeShuffle) {
            self.shuffle()
        }
    }
}
