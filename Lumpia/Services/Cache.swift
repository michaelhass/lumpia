//
//  Cache.swift
//  Lumpia
//
//  Created by Michael Haß on 22.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

/// Wrapper around NSCache. Allows using any hashable key and any kind of value.
final class Cache<Key: Hashable, Value> {

    private let cache: NSCache<WrappedKey, WrappedValue> = .init()

    subscript(key: Key) -> Value? {
        get {
            cache.object(forKey: .init(key: key))?.value
        } set {
            guard let value = newValue else {
                // If the value is nil, remove entry from cache
                cache.removeObject(forKey: .init(key: key))
                return
            }
            cache.setObject(.init(value: value), forKey: .init(key: key))
        }
    }

    // MARK: Wrapped Key

    /// Wraps the Key into an NSObject so it can be used with  NSCache.
    /// NSCache<KeyType, ObjectType> : NSObject where KeyType : AnyObject...
    private final class WrappedKey: NSObject {
        let key: Key

        init(key: Key) {
            self.key = key
        }

        override var hash: Int {
            key.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }

    // MARK: Wrapped Value

    /// Wraps the Value into an NSObject so it can be used with  NSCache.
    /// NSCache<KeyType, ObjectType> :..., ObjectType : AnyObject
    private final class WrappedValue {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}
