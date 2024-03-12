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
    var draggedIndex: Int?
    
    let index: Int = 0
    var tileImages: [UIImage] = []
    
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
        withAnimation {
            self.tileImages = images
        }
    }
}

extension PuzzleBoardViewModel: DropDelegate {
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedIndex = draggedIndex else { return false }
        
        /// Swap the images in the tiles array
        tileImages.swapAt(draggedIndex, index)
        return true
    }
}
