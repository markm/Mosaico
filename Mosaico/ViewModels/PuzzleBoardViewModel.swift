//
//  PuzzleBoardViewModel.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import UIKit

@Observable
class PuzzleBoardViewModel {
    
    var image: UIImage?
    
    var imageService: ImageServiceProtocol
    
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    func fetchImage() async throws {
        guard let url = Endpoint.largeImage.url else {
            throw ImageError.invalidURL
        }
        do {
            self.image = try await imageService.fetchImage(fromURL: url)
        } catch {
            throw ImageError.failedToLoadImage
        }
    }
}
