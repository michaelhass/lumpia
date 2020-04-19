//
//  ServiceError.swift
//  Lumpia
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

enum ServiceError: Swift.Error {
    case noResponse
    case missingResponseHeaderField(String)
    case exceededRateLimit
    case networkingError(Swift.Error)
    case decodingError(Swift.Error)
 }
