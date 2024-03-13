//
//  DragPieceDelegate.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import SwiftUI

class DragPieceDelegate: DropDelegate {
    
    var originalPiece: PuzzlePiece
    
    @Binding var isComplete: Bool
    @Binding var gridSpacing: CGFloat
    @Binding var pieces: [PuzzlePiece]
    @Binding var currentPiece: PuzzlePiece?
    
    // MARK: - Initializer
    
    init(originalPiece: PuzzlePiece,
         pieces: Binding<[PuzzlePiece]>,
         gridSpacing: Binding<CGFloat>,
         isComplete: Binding<Bool>,
         currentPiece: Binding<PuzzlePiece?>) {
        self.originalPiece = originalPiece
        self._pieces = pieces
        self._isComplete = isComplete
        self._currentPiece = currentPiece
        self._gridSpacing = gridSpacing
    }
    
    // MARK: - DropDelegate

    func performDrop(info: DropInfo) -> Bool {
        if originalPiece != currentPiece {
            /// Makes sure neither of the pieces are in their home position
            guard currentPiece?.isHome == false &&
                  originalPiece.isHome == false else {
                return false
            }
            /// Gets the indices of the pieces in the array & update the current index of each piece
            let fromIndex = pieces.firstIndex(of: currentPiece!)!
            let toIndex = pieces.firstIndex(of: originalPiece)!
            currentPiece?.currentIndex = toIndex
            self.originalPiece.currentIndex = fromIndex
            /// Swaps the pieces in the array
            withAnimation {
                pieces.swapAt(fromIndex, toIndex)
                self.currentPiece = nil
            }
            /// Checks if the puzzle is complete
            let done = pieces.allSatisfy { $0.isHome }
            if done {
                print("Puzzle is complete")
                withAnimation {
                    gridSpacing = 0
                    isComplete = true
                }
            }
        }
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
}
