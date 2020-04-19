//
//  UnsplashService.swift
//  Lumpia
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

/// Service for performing request against the Unsplash API
final class UnsplashService {

    // MARK: Nested types

    enum EndPoint {
        case search(String)
        
        var path: String {
            switch self {
            case .search: return "search/photos"
            }
        }
    }

    typealias CompletionHandler<T> = (Result<T, ServiceError>) -> Void
    typealias DecodingHandler<T> = (Data, URLResponse) throws -> T

    // MARK: Properties

    let baseURL: URL
    let apiKey: String
    let session: URLSession

    // MARK: Init

    init(baseURL: URL, apiKey: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.session = session
    }

    // MARK: API

    /// Creates URLSessionTasks to request a codable object from the specified endpoint
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to request data from
    ///   - decode: Closure to create a native object from the response data.
    ///   - completion: Excuted if task finished loading.
    /// - Returns: URLSessionTask if task could be created
    func request<T>(_ endpoint: EndPoint,
                    decode: @escaping DecodingHandler<T>,
                    completion: @escaping CompletionHandler<T>) -> URLSessionTask? {

        urlRequest(for: endpoint).map {
            $0.settingAuthorization(apiKey: apiKey)

        }.map {
            session.dataTask(with: $0) { (data, response, error) in

                let completeOnMain: (Result<T, ServiceError>) -> Void = { result in
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }

                guard error == nil else { return completeOnMain(.failure(.networkingError(error!))) }
                guard let data = data, let response = response else { return  completeOnMain(.failure(.noResponse)) }

                do {
                    completion(.success(try decode(data, response)))

                } catch let decodingError {
                    completeOnMain(.failure(.decodingError(decodingError)))
                }
            }
        }
    }

    /// Constructs an URL request for the given Endpoint.
    ///
    /// - Parameter endpoint: Endpoint to construct the request for
    /// - Returns: Returns and URLRequest object if construction was successful.
    private func urlRequest(for endpoint: EndPoint) -> URLRequest? {
        let url = baseURL.appendingPathComponent(endpoint.path)

        switch endpoint {
        case .search(let term):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = [.init(name: "query", value: term)]
            return components?.url.map {
                URLRequest.init(url: $0)
            }
        }
    }

}

// MARK: - Extension URLRequest

fileprivate extension URLRequest {

    func settingAuthorization(apiKey: String) -> URLRequest {
        var request = self
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}
