//
//  PuzzlePiece.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import UIKit

struct PuzzlePiece {
    
    var id = UUID()
    var image: UIImage
    var originalIndex: Int
    var currentIndex: Int

    init(image: UIImage, index: Int) {
        self.image = image
        self.originalIndex = index
        self.currentIndex = index 
    }
}

extension PuzzlePiece: Reorderable {
    static func == (lhs: PuzzlePiece, rhs: PuzzlePiece) -> Bool {
        lhs.id == rhs.id
    }
}
