//
//  AppFonts.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import SwiftUI

struct AppFonts {
    
    static func avenirNext(ofSize size: CGFloat, weight: FontWeight = .regular) -> Font {
        switch weight {
        case .regular:
            return Font.custom("AvenirNext-Regular", size: size)
        case .bold:
            return Font.custom("AvenirNext-Bold", size: size)
        }
    }
    
    static func optima(ofSize size: CGFloat, weight: FontWeight = .regular) -> Font {
        switch weight {
        case .regular:
            return Font.custom("Optima-Regular", size: size)
        case .bold:
            return Font.custom("Optima-Bold", size: size)
        }
    }
}

enum FontWeight {
    case regular
    case bold
}
