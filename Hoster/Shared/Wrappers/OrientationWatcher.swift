//
//  OrientationWatcher.swift
//  Hoster
//
//  Created by Stan Potemkin on 26.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class OrientationWatcher: ObservableObject {
    @Published var interfaceOrientation: UIInterfaceOrientation
    
    private let windowScene: UIWindowScene
    
    private var observer: AnyCancellable?
    
    init(windowScene: UIWindowScene) {
        self.interfaceOrientation = windowScene.interfaceOrientation
        self.windowScene = windowScene
        
        observer = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .compactMap { [weak self] _ in self?.windowScene.interfaceOrientation }
            .removeDuplicates()
            .sink(receiveValue: { [weak self] _ in self?.objectWillChange.send() })
    }
}
