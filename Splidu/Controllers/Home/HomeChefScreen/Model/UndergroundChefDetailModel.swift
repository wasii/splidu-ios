//
//  UndergroundChefDetailModel.swift
//  Splidu
//
//  Created by Wasiq Saleem on 23/09/2022.
//

import Foundation
// MARK: - Welcome
struct UndergroundChefDetailModel: Codable {
    let baseURL: String?
    let code: Int?
    let status: String?
    let chef: Chef?
    let chefDinings: ChefDinings?

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case code, status, chef
        case chefDinings = "chef_dinings"
    }
}

// MARK: - Chef
struct Chef: Codable {
    let id: Int?
    let review, name, firstName, lastName: String?
    let email: String?
    let mobile: String?
    let active: Int?
    let userImage, chefDescription: String?
    let chefMasterimage, brandName: String?
    let favoriteCount: Int?
    let chefImages: [ChefImage]?

    enum CodingKeys: String, CodingKey {
        case id, review, name
        case firstName = "first_name"
        case lastName = "last_name"
        case email, mobile, active
        case userImage = "user_image"
        case chefDescription = "description"
        case chefMasterimage = "chef_masterimage"
        case brandName = "brand_name"
        case favoriteCount = "favorite_count"
        case chefImages = "chef_images"
    }
}

// MARK: - ChefImage
struct ChefImage: Codable {
    let path: String?
    let chefID: Int?

    enum CodingKeys: String, CodingKey {
        case path
        case chefID = "chef_id"
    }
}

// MARK: - ChefDinings
struct ChefDinings: Codable {
    let currentPage: Int?
    let chefDinigDetail: [ChefDiningDetails]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case chefDinigDetail = "data"
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - ChefDiningDetails
struct ChefDiningDetails: Codable {
    let id, chefID: Int?
    let title, slug, priceType, pricePerson: String?
    let discountPrice: String?
    var isFavourite: Int?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case chefID = "chef_id"
        case title, slug
        case priceType = "price_type"
        case pricePerson = "price_person"
        case discountPrice = "discount_price"
        case isFavourite = "favorite_count"
        case image
    }
}
