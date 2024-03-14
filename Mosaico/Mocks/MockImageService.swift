//
//  MockImageService.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class MockImageService: ImageServiceProtocol {
    
    var image: UIImage?
    var error: ImageError?
    
    func fetchImage(fromURL url: URL) async throws -> UIImage {
        if let error = error {
            throw error
        }
        return image ?? UIImage()
    }
}
