//
//  PuzzlePiece.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import UIKit

class PuzzlePiece {
    
    var id = UUID()
    var originalIndex: Int
    var currentIndex: Int
    var image: UIImage

    var isHome: Bool {
        currentIndex == originalIndex
    }
    
    init(image: UIImage, index: Int) {
        self.image = image
        self.currentIndex = index
        self.originalIndex = index
    }
}

extension PuzzlePiece: Reorderable {
    static func == (lhs: PuzzlePiece, rhs: PuzzlePiece) -> Bool {
        lhs.id == rhs.id
    }
}
