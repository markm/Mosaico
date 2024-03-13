//
//  PuzzleTile.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import SwiftUI

struct PuzzleTile: View {
    var piece: PuzzlePiece
    var body: some View {
        Image(uiImage: piece.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    PuzzleTile(piece: PuzzlePiece(image: UIImage(systemName: "mosiac")!, index: 0))
}
