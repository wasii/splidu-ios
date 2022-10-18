//
//  MyProfileModel.swift
//  Splidu
//
//  Created by NaheedPK on 15/09/2022.
//

import Foundation

// MARK: - Welcome
struct MyProfileModel: Codable {
    let base_url: String?
    let code: Int?
    let status: String?
    let user: MyProfileUser?
//    let interests, allergens, dietarys: [BookingAttributesDetails]?
    let interests: [Interest]?
    let allergens: [AllergenElement]?
    let dietarys: [Dietary]?
}
// MARK: - AllergenElement
struct AllergenElement: Codable {
    let allergenID: Int?
    let allergen: BookingAttributesDetails?

    enum CodingKeys: String, CodingKey {
        case allergenID = "allergen_id"
        case allergen
    }
}
// MARK: - Dietary
struct Dietary: Codable {
    let dietaryID: Int?
    let dietary: BookingAttributesDetails?

    enum CodingKeys: String, CodingKey {
        case dietaryID = "dietary_id"
        case dietary
    }
}

// MARK: - Interest
struct Interest: Codable {
    let interestID: Int?
    let interests: BookingAttributesDetails?

    enum CodingKeys: String, CodingKey {
        case interestID = "interest_id"
        case interests
    }
}

// MARK: - User
struct MyProfileUser: Codable {
    let id: Int?
    let dateOfBirth, fbLink, twLink, inLink: String?
    let liLink, gender: String?
    let name, email: String?
    let dialCode: String?
    let mobile, firstName, lastName: String?
    let userImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case dateOfBirth = "date_of_birth"
        case fbLink = "fb_link"
        case twLink = "tw_link"
        case inLink = "in_link"
        case liLink = "li_link"
        case gender, name, email
        case dialCode = "dial_code"
        case mobile
        case firstName = "first_name"
        case lastName = "last_name"
        case userImage = "user_image"
    }
}
