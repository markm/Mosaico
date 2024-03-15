//
//  MosaicoTests.swift
//  MosaicoTests
//
//  Created by Mark Mckelvie on 3/12/24.
//

import XCTest
@testable import Mosaico

final class MosaicoTests: XCTestCase {
    
    var image: UIImage!
    var imageService: MockImageService!
    var puzzleBoardViewModel: PuzzleBoardViewModel!

    override func setUpWithError() throws {
        image = UIImage(systemName: "photo")
        imageService = MockImageService()
        imageService.image = image
        puzzleBoardViewModel = PuzzleBoardViewModel(imageService: imageService)
    }

    override func tearDownWithError() throws {
        imageService = nil
        puzzleBoardViewModel = nil
    }
    
    func testFetchImageSuccess() async throws {
        // When
        do {
            try await puzzleBoardViewModel.fetchImage()
            // Then
            XCTAssertFalse(puzzleBoardViewModel.pieces.isEmpty, "Array should not be empty")
        } catch {
            XCTFail("Fetching image should not have failed")
        }
    }
    
    func testFetchImageFailure() async throws {
        // Given
        let mockService = MockImageService()
        mockService.error = ImageError.failedToLoadImage
        let viewModel = PuzzleBoardViewModel(imageService: mockService)
        
        // When
        do {
            try await viewModel.fetchImage()
            XCTFail("Fetching image should have failed")
        } catch let error as ImageError {
            // Then
            XCTAssertEqual(error, .failedToLoadImage)
        }
    }
    
    func testShuffle() {
        // Given
        let puzzlePieces: [PuzzlePiece] = (1...9).map { PuzzlePiece(image: UIImage(), index: $0) }
        puzzleBoardViewModel.pieces = puzzlePieces
        
        // When
        puzzleBoardViewModel.shuffle()
        
        // Then
        XCTAssertNotEqual(puzzlePieces.map { $0.id },
                          puzzleBoardViewModel.pieces.map { $0.id }, "Pieces should be shuffled")
        XCTAssertTrue(puzzlePieces != puzzleBoardViewModel.pieces,
                      "The currentPieces array should be in a different order after shuffling")
    }
    
    func testSplitImage() async {
        puzzleBoardViewModel.splitImage(image)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + kSecondsBeforeShuffle) {
            /// Postconditions: originalPieces and currentPieces should be populated
            XCTAssertFalse(self.puzzleBoardViewModel.pieces.isEmpty,
                           "originalPieces should be populated after splitting the image.")
            XCTAssertFalse(self.puzzleBoardViewModel.pieces.isEmpty, 
                           "currentPieces should be populated after splitting the image.")
            
            /// Validate the number of pieces
            XCTAssertEqual(self.puzzleBoardViewModel.pieces.count,
                           kGridLength * kGridLength,
                           "There should be \(kGridLength * kGridLength) pieces after splitting the image.")
        }
    }
}
