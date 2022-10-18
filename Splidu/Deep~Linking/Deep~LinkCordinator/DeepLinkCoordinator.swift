//
//  DeepLinkCoordinator.swift
//  Splidu
//
//  Created by Muneeb on 27/09/2022.
//

import Foundation
protocol DeeplinkCoordinatorProtocol {
    @discardableResult
    func handleURL(_ url: URL) -> Bool
}

final class DeeplinkCoordinator {
    let handlers: [DeeplinkHandlerProtocol]
    init(handlers: [DeeplinkHandlerProtocol]) {
        self.handlers = handlers
    }
}

// MARK: - DeepLink Coordinator Protocol
extension DeeplinkCoordinator: DeeplinkCoordinatorProtocol {
    @discardableResult
    func handleURL(_ url: URL) -> Bool{
        guard let handler = handlers.first(where: { $0.canOpenURL(url) }) else {
            return false
        }
        handler.openURL(url)
        return true
    }
}
