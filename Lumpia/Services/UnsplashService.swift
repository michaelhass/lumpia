//
//  UnsplashService.swift
//  Lumpia
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

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

    typealias CompetionHandler<T> = (Result<T, ServiceError>) -> Void

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

    /// Requests an codable object from the specified endpoint
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to request data from
    ///   - completion: Excuted if task finished loading.
    /// - Returns: URLSessionTask if task could be created
    func request<T: Codable>(_ endpoint: EndPoint,
                             completion: @escaping CompetionHandler<T>) -> URLSessionTask? {

        urlRequest(for: endpoint).map {
            $0.settingAuthorization(apiKey: apiKey)
        }.map {
            session.dataTask(with: $0) { (data, _, error) in

                let completeOnMain: (Result<T, ServiceError>) -> Void = { result in
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }

                // TODO: Check response
                guard error == nil else { return completeOnMain(.failure(.networkingError(error!))) }
                guard let data = data else { return  completeOnMain(.failure(.noResponse)) }

                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))

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

fileprivate extension URLRequest {

    func settingAuthorization(apiKey: String) -> URLRequest {
        var request = self
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}
