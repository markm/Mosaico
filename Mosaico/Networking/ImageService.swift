//
//  ImageService.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class ImageService: ImageServiceProtocol {

    @MainActor
    func fetchImage(fromURL url: URL) async throws -> UIImage {
        /// Directly await the response of the image request
        let response: DataResponse<UIImage, AFError> = await AF.request(url).serializingImage().response
        /// Directly access the result's value, which is of type UIImage
        guard let image = response.value else {
            throw ImageError.failedToLoadImage
        }
        return image
    }
}
