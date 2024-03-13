//
//  Constants.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation

// Fonts
let kTitleFontSize: CGFloat = 26
let kLargeFontSize: CGFloat = 24
let kSmallFontSize: CGFloat = 14
let kMediumFontSize: CGFloat = 18
let kRegularFontSize: CGFloat = 16

// Padding
let kSmallPadding: CGFloat = 8
let kLargePadding: CGFloat = 24
let kMediumPadding: CGFloat = 16

// Spacing
let kGridSpacing: CGFloat = 5

// Radii
let kShadowRadius: CGFloat = 5
let kPuzzleBoardCornerRadius: CGFloat = 25
let kDefaultCornerRadius: CGFloat = 16

// Misc Dimensions
let kBorderWidth: CGFloat = 1
let kTitleHeight: CGFloat = 60
let kShadowHeight: CGFloat = 5
let kShadowOpacity: Float = 0.5

// Misc Strings
let kDoneTitle = "Done"
let kResetTitle = "Reset"
let kMosaicoTitle = "Mosaico"
let kDefaultRecoverySuggestion = "Try again, or contact help@mosaico.com"
let kInitNotImplementedErrorMessage = "init(coder:) has not been implemented"

public typealias Reorderable = Identifiable & Equatable

