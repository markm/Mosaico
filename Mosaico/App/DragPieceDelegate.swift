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

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if originalPiece != currentPiece {
            let from = pieces.firstIndex(of: currentPiece!)!
            let to = pieces.firstIndex(of: originalPiece)!
            
            guard currentPiece?.isHome == false else {
                return false
            }
            
            currentPiece?.currentIndex = to
            self.originalPiece.currentIndex = from
            
            withAnimation {
                pieces.swapAt(from, to)
                self.currentPiece = nil
            }
            
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
}
