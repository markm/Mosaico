//
//  ButtonStyles.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/13/24.
//

import Foundation
import SwiftUI

struct StartOverButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, kMediumPadding)
            .padding(.horizontal, kLargePadding)
            .background(Color.mGreen)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .font(AppFonts.optima(ofSize: kRegularFontSize))
    }
}
