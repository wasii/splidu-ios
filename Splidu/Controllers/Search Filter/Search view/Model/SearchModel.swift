//
//  SearchModel.swift
//  Splidu
//
//  Created by Wasiq Saleem on 16/09/2022.
//

import Foundation
// MARK: - Welcome
struct SearchModel: Codable {
    let status: String
    let code: Int
    let data: SearchDataClass
}

// MARK: - DataClass
struct SearchDataClass: Codable {
    let currentPage: Int?
    let data: [SearchDataClassData]?
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
struct SearchDataClassData: Codable {
    let id: Int?
    let name: String?
    let type: TypeEnum?
    let slug, priceType, pricePerson, discountPrice: String?
    let firstName, lastName, email: String?
    let mobile: String?
    let active: Int?
    let userImage, datumDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name, type, slug
        case priceType = "price_type"
        case pricePerson = "price_person"
        case discountPrice = "discount_price"
        case firstName = "first_name"
        case lastName = "last_name"
        case email, mobile, active
        case userImage = "user_image"
        case datumDescription = "description"
    }
}

enum TypeEnum: String, Codable {
    case chef = "chef"
    case event = "event"
}
