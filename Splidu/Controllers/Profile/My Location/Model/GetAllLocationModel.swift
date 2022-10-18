//
//  GetAllLocationModel.swift
//  Splidu
//
//  Created by NaheedPK on 15/09/2022.
//

import Foundation

// MARK: - Welcome
struct GetAllLocationModel: Codable {
    let status, code: String?
    let data: [LocationData]?
}

// MARK: - Datum
struct LocationData: Codable {
    let id, userID: Int?
    let buildingName, floorNo, streetAddress, countryName: String?
    let addressType: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case buildingName = "building_name"
        case floorNo = "floor_no"
        case streetAddress = "street_address"
        case countryName = "country_name"
        case addressType = "address_type"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//MARK: Success Fail Model
struct SuccessFailModel: Codable {
    let code: Int?
    let message: String?
    let status: String?
    let order_number: String?
    let confirmed_seats: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message, status
        case order_number
        case confirmed_seats
    }
}
