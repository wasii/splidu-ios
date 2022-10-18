//
//  BookingAttributesModel.swift
//  Splidu
//
//  Created by Wasiq Saleem on 16/09/2022.
//// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - BookingAttributesModel
struct BookingAttributesModel: Codable {
    let status: String?
    let code: Int?
    let allergens, dietaryRestrictions, dislikes, interests: [BookingAttributesDetails]?

    enum CodingKeys: String, CodingKey {
        case status, code, allergens
        case dietaryRestrictions = "dietary_restrictions"
        case dislikes, interests
    }
}

// MARK: - Allergen
struct BookingAttributesDetails: Codable {
    let id: Int?
    let title, file: String?
    let status: Int?
    let deletedAt: String?
    let createdAt, updatedAt: String?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, title, file, status
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
