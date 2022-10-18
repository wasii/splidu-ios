//
//  ChangePasswordModel.swift
//  Splidu
//
//  Created by abdWasiq on 14/09/2022.
//

import Foundation
struct ChangePasswordModel: Codable {
    let code: Int?
    let message: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case status
    }
}
