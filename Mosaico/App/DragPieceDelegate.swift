//
//  DragPieceDelegate.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import SwiftUI

class DragPieceDelegate: DropDelegate {
    
    var piece: PuzzlePiece
    @Binding var pieces: [PuzzlePiece]
    @Binding var current: PuzzlePiece?
    
    // MARK: - Initializer
    
    init(piece: PuzzlePiece, pieces: Binding<[PuzzlePiece]>, current: Binding<PuzzlePiece?>) {
        self.piece = piece
        self._pieces = pieces
        self._current = current
    }
    
    // MARK: - DropDelegate

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if piece != current {
            let from = pieces.firstIndex(of: current!)!
            let to = pieces.firstIndex(of: piece)!
            
            guard current?.isHome == false else {
                return false
            }
            
            current?.currentIndex = to
            self.piece.currentIndex = from
            
            withAnimation {
                pieces.swapAt(from, to)
                self.current = nil
            }
        }
        return true
    }
}
