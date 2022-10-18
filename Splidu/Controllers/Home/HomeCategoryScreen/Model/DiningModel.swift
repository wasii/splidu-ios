//
//  DiningModel.swift
//  Splidu
//
//  Created by abdWasiq on 14/09/2022.
//

import Foundation
// MARK: - Welcome
struct HomeDiningModel: Codable {
    let code: Int?
    let status: String?
    let dinings: HomeDinings?
}

// MARK: - Dinings
struct HomeDinings: Codable {
    let currentPage: Int?
    let data: [HomeDiningsData]?
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

// MARK: - Datum
struct HomeDiningsData: Codable {
    let id, chefID: Int?
    let title, slug: String?
    let priceType: HomeDiningsDataPriceType?
    let pricePerson, discountPrice, location: String?

    enum CodingKeys: String, CodingKey {
        case id
        case chefID = "chef_id"
        case title, slug
        case priceType = "price_type"
        case pricePerson = "price_person"
        case discountPrice = "discount_price"
        case location
    }
}

enum HomeDiningsDataPriceType: String, Codable {
    case donation = "donation"
    case price = "price"
}
