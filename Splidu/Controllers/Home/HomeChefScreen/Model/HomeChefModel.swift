//
//  HomeChefModel.swift
//  Splidu
//
//  Created by abdWasiq on 14/09/2022.
//

import Foundation
// MARK: - HomeChefModel
struct HomeChefModel: Codable {
    let code: Int?
    let status: String?
    let chef: HomeChef?
    let chefDinings: HomeChefDinings?

    enum CodingKeys: String, CodingKey {
        case code, status, chef
        case chefDinings = "chef_dinings"
    }
}

// MARK: - HomeChef
struct HomeChef: Codable {
    let id: Int?
    let name, firstName, lastName, email: String?
    let mobile: String?
    let active: Int?
    let userImage, chefDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case firstName = "first_name"
        case lastName = "last_name"
        case email, mobile, active
        case userImage = "user_image"
        case chefDescription = "description"
    }
}

// MARK: - HomeChefDinings
struct HomeChefDinings: Codable {
    let currentPage: Int?
    let data: [HomeChefDiningsData]?
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

// MARK: - HomeChefDiningsData
struct HomeChefDiningsData: Codable {
    let id, chefID: Int?
    let title, slug, priceType, pricePerson: String?
    let discountPrice: String?

    enum CodingKeys: String, CodingKey {
        case id
        case chefID = "chef_id"
        case title, slug
        case priceType = "price_type"
        case pricePerson = "price_person"
        case discountPrice = "discount_price"
    }
}
