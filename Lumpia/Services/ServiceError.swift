//
//  ServiceError.swift
//  Lumpia
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

enum ServiceError: Swift.Error, Equatable {
    case noResponse
    case exceededRateLimit
    case networkingError(Swift.Error)
    case decodingError(Swift.Error)

    static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.noResponse, .noResponse):
            return true
        case (.exceededRateLimit, .exceededRateLimit):
            return true
        case (.networkingError, .networkingError):
            return true
        case (.decodingError, .decodingError):
            return true
        default:
            return false
        }
    }
 }
