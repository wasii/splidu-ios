//
//  DeepLinkHandlerProtocol.swift
//  Splidu
//
//  Created by Muneeb on 27/09/2022.
//

import Foundation
protocol DeeplinkHandlerProtocol {
    func canOpenURL(_ url: URL) -> Bool
    func openURL(_ url: URL)
}
