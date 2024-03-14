//
//  UIImage+Splitting.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/14/24.
//

import Foundation
import UIKit

extension UIImage {
    
    func splitIntoPieces() -> [PuzzlePiece] {
        var images: [UIImage] = []
        
        /// get the size of each piece
        let size = CGSize(width: size.width / CGFloat(kGridLength), height: size.height / CGFloat(kGridLength))
        
        /// iterates over each row and column of the grid.
        for y in 0..<kGridLength {
            for x in 0..<kGridLength {
                /// create a new image context and draw the image into it, offsetting the image by the size of the piece.
                UIGraphicsBeginImageContext(size)
                
                /// draw the image into the context at the negative x and y coordinates of the current piece.
                draw(at: CGPoint(x: -CGFloat(x) * size.width, y: -CGFloat(y) * size.height))
                
                /// get the image from the context and append it to the images array.
                let tileImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if let tileImage = tileImage {
                    images.append(tileImage)
                }
            }
        }
        
        /// return an array of PuzzlePiece objects, each with an image and an index.
        return images.enumerated().map { (index, image) in PuzzlePiece(image: image, index: index) }
    }
}
