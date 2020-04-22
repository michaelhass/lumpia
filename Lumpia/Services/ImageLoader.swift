//
//  ImageLoader.swift
//  Lumpia
//
//  Created by Michael Haß on 22.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI
import Combine

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

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let url: URL
    private var cancellable: AnyCancellable?
    private let cache: Cache<URL, UIImage>?
    private(set) var isLoading = false
    private let imageQueue: DispatchQueue = .init(label: "image_ioader_queue")
    public var objectWillChange: AnyPublisher<UIImage?, Never>
        = Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()

    init(url: URL, cache: Cache<URL, UIImage>? = nil) {
        self.url = url
        self.cache = cache

        self.objectWillChange = $image.handleEvents(receiveSubscription: { [weak self] _ in
                  self?.load()
            }, receiveCancel: { [weak self] in
                self?.cancel()
        }).eraseToAnyPublisher()
    }

    deinit {
        cancellable?.cancel()
    }

    func load() {
        if let image = cache?[url] {
            self.image = image
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, _) -> UIImage? in UIImage(data: data) }
            .catch({ _ in Just(nil) })
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    func cancel() {
        cancellable?.cancel()
    }
}
