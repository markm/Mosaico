//
//  Endpoint.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation

enum Endpoint {
    case largeImage
}

extension Endpoint {
    
    enum Method {
        case GET
        case POST(data: Data?)
    }
}

extension Endpoint {
    
    private var host: String { "picsum.photos" }
    
    private var path: String {
        switch self {
        case .largeImage:
            return "/1024"
        }
    }
    
    private var method: Method {
        switch self {
        case .largeImage:
            return .GET
        }
    }
}

extension Endpoint {
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        return urlComponents.url
    }
}

