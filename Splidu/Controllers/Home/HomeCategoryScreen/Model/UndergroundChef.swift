//
//  UndergroundChef.swift
//  Splidu
//
//  Created by Wasiq Saleem on 23/09/2022.
//

import Foundation
struct UndergroundChefsModel: Codable {
    let baseURL: String?
    let code: Int?
    let status: String?
    let nearByChefs: [NearByChef]?
    let chefs: Chefs?

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case code, status
        case nearByChefs = "near_by_chefs"
        case chefs
    }
}

// MARK: - Chefs
struct Chefs: Codable {
    let currentPage: Int?
    let data: [NearByChef]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL, nextPageURL, path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
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

// MARK: - NearByChef
struct NearByChef: Codable {
    let id: Int?
    let name, firstName, lastName, chefMasterimage: String?
    let nearByChefDescription: String?
    let brandName, profileImage: String?
    var isFavourite: Int?
    var chefCuisines: [ChefCuisines]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case firstName = "first_name"
        case lastName = "last_name"
        case chefMasterimage = "chef_masterimage"
        case nearByChefDescription = "description"
        case brandName = "brand_name"
        case profileImage = "profile_image"
        case isFavourite = "favorite_count"
        case chefCuisines = "chef_cusines"
    }
}

//MARK: Chef Cuisines
struct ChefCuisines: Codable {
    let id, cuisineID, chefID: Int?
    let cuisine: ChefCuisineDetail?

    enum CodingKeys: String, CodingKey {
        case id
        case cuisineID = "cuisine_id"
        case chefID = "chef_id"
        case cuisine
    }
}

// MARK: - ChefCuisineDetail
struct ChefCuisineDetail: Codable {
    let id: Int?
    let title: String?
}
