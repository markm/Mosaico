//
//  Protocols.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import UIKit

protocol ImageServiceProtocol: AnyObject {
    func fetchImage(fromURL url: URL) async throws -> UIImage
}
