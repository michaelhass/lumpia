//
//  Shared.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation
import SwiftUI

/// Container for every shared service.
public struct Shared {
    let unsplash: UnsplashService
    let imageCache: Cache<URL, UIImage>
}
