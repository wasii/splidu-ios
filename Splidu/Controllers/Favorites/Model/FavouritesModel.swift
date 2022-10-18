//
//  FavouritesModel.swift
//  Splidu
//
//  Created by abdWasiq on 13/09/2022.
//

import Foundation

// MARK: - FavouriteChefModel
struct FavouritesChefModel: Codable {
    let base_url: String?
    let status: String?
    let code: Int?
    let data: [FavouritesChefData]?
    let length: Int?
}

// MARK: - FavouriteChefData
struct FavouritesChefData: Codable {
    let id, joinID, userID: Int?
    let createdAt, updatedAt, type: String?
    let chef: FavoriteChef?

    enum CodingKeys: String, CodingKey {
        case id
        case joinID = "join_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case type, chef
    }
}

// MARK: - FavouriteChef
struct FavoriteChef: Codable {
    let id: Int?
    let name, firstName, lastName, email: String?
    let mobile: String?
    let active: Int?
    let userImage, welcomeDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case firstName = "first_name"
        case lastName = "last_name"
        case email, mobile, active
        case userImage = "user_image"
        case welcomeDescription = "description"
    }
}



// MARK: - Remove Favourites
struct RemoveFavouriteChef: Codable {
    let status: String?
    let code: Int?
    let message: String?
}



// MARK: - FavouriteDiningModel
struct FavouriteDiningModel: Codable {
    let base_url: String?
    let status: String?
    let code: Int?
    let data: [FavouriteDining]?
    let length: Int?
}

// MARK: - FavouriteDining
struct FavouriteDining: Codable {
    let id, joinID, userID: Int?
    let createdAt, updatedAt, type: String?
    let dining: FavouriteDiningData?

    enum CodingKeys: String, CodingKey {
        case id
        case joinID = "join_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case type, dining
    }
}

// MARK: - FavouriteDiningData
struct FavouriteDiningData: Codable {
    let id, chefID: Int?
    let title, slug, priceType, pricePerson: String?
    let discountPrice: String?
    let diningImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case chefID = "chef_id"
        case title, slug
        case priceType = "price_type"
        case pricePerson = "price_person"
        case discountPrice = "discount_price"
        case diningImage = "dining_image"
    }
}
