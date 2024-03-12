//
//  GameStats.swift
//  Mosaico
//
//  Created by Mark Mckelvie on 3/12/24.
//

import Foundation
import SwiftData

@Model
final class GameStats {
    
    @Attribute var created = Date.now
    @Attribute var score = 0
    
    init() {}
}
