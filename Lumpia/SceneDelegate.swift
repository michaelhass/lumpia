//
//  SceneDelegate.swift
//  Lumpia
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import UIKit
import SwiftUI

// Object containing all services used by the application
var shared: Shared?

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let appStateStore = Store<AppState>.init(initialState: .initialState,
                                                     reducer: appReducer(state:action:))

    override init() {
        super.init()

        let baseURL = URL(string: "https://api.unsplash.com/")!
        let apiKey = "hi1fmxPWeaX6cIo9YE6k8FvpDXzp15V280hQngaTx1U"
        let unsplash = UnsplashService(baseURL: baseURL, apiKey: apiKey)
        shared = .init(unsplash: unsplash)
    }

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        let contentView = GalleryView().environmentObject(appStateStore)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
