//
//  MosaicoTests.swift
//  MosaicoTests
//
//  Created by Mark Mckelvie on 3/12/24.
//

import XCTest
@testable import Mosaico

final class MosaicoTests: XCTestCase {
    
    var imageService: MockImageService!
    var puzzleBoardViewModel: PuzzleBoardViewModel!

    override func setUpWithError() throws {
        imageService = MockImageService()
        imageService.image = UIImage(systemName: "photo")
        puzzleBoardViewModel = PuzzleBoardViewModel(imageService: imageService)
        puzzleBoardViewModel.image = UIImage(systemName: "photo")
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
            XCTAssertNotNil(puzzleBoardViewModel.image)
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
        puzzleBoardViewModel.originalPieces = puzzlePieces
        puzzleBoardViewModel.pieces = puzzlePieces
        
        // When
        puzzleBoardViewModel.shuffle()
        
        // Then
        XCTAssertNotEqual(puzzleBoardViewModel.pieces.map { $0.id },
                          puzzleBoardViewModel.originalPieces.map { $0.id }, "Pieces should be shuffled")
        XCTAssertTrue(puzzleBoardViewModel.pieces != puzzleBoardViewModel.originalPieces,
                      "The currentPieces array should be in a different order after shuffling")
    }
    
    func testSplitImage() async {
        /// Precondition: The ViewModel's image is set
        XCTAssertNotNil(puzzleBoardViewModel.image, "Image must be set before splitting.")

        puzzleBoardViewModel.splitImage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + kSecondsBeforeShuffle) {
            /// Postconditions: originalPieces and currentPieces should be populated
            XCTAssertFalse(self.puzzleBoardViewModel.originalPieces.isEmpty,
                           "originalPieces should be populated after splitting the image.")
            XCTAssertFalse(self.puzzleBoardViewModel.pieces.isEmpty, 
                           "currentPieces should be populated after splitting the image.")
            
            /// Validate the number of pieces
            XCTAssertEqual(self.puzzleBoardViewModel.originalPieces.count,
                           kGridLength * kGridLength,
                           "There should be \(kGridLength * kGridLength) pieces after splitting the image.")
        }
    }
}
