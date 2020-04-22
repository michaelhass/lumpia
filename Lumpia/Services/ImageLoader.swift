//
//  ImageLoader.swift
//  Lumpia
//
//  Created by Michael Haß on 22.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI
import Combine

/// Observable image loader. Requests an Image from the given url.
/// Can optionally use a Cache for better peformance.
final class ImageLoader: ObservableObject {

    // MARK: Bindings
    @Published var image: UIImage?

    // MARK: Properties
    private let url: URL
    private let cache: Cache<URL, UIImage>?

    private var cancellable: AnyCancellable?
    public var objectWillChange: AnyPublisher<UIImage?, Never>
        = Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()

    // MARK: Init

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
            .catch { _ in Just(nil) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    func cancel() {
        cancellable?.cancel()
    }
}
