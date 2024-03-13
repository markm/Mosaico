//
//  DragPieceDelegate.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import SwiftUI

struct DragPieceDelegate: DropDelegate {
    
    let piece: PuzzlePiece
    @Binding var pieces: [PuzzlePiece]
    @Binding var current: PuzzlePiece?

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if piece != current {
            let from = pieces.firstIndex(of: current!)!
            let to = pieces.firstIndex(of: piece)!
            withAnimation {
                pieces.swapAt(from, to)
                self.current = nil
            }
        }
        return true
    }
}
