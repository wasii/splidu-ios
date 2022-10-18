// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - HomeModel
struct HomeModel: Codable {
    let baseURL: String?
    let status, code: String?
    var sliders, categories: [Category]?
    let featuredChefs: [FeaturedChef]?
    let dinings: [Dining]?

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case status, code, sliders, categories
        case featuredChefs = "featured_chefs"
        case dinings
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let title: String?
    let status: Int?
    let deletedAt: String?
    let createdAt, updatedAt: String?
    let image: String?
    let categoryDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, title, status
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case image
        case categoryDescription = "description"
    }
}

// MARK: - Dining
struct Dining: Codable {
    let title: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id, chefID: Int?
    let title, slug: String?
    let price_type: String?
    let pricePerson, discountPrice: String?
    let image: String?
    let favorite_count: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case chefID = "chef_id"
        case title, slug
        case price_type
        case pricePerson = "price_person"
        case discountPrice = "discount_price"
        case image
        case favorite_count
    }
}

// MARK: - FeaturedChef
struct FeaturedChef: Codable {
    let id: Int?
    let name, firstName, lastName, email: String?
    let mobile: String?
    let active: Int?
    let userImage, welcomeDescription: String?
    let favorite_count: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case firstName = "first_name"
        case lastName = "last_name"
        case email, mobile, active
        case userImage = "user_image"
        case welcomeDescription = "description"
        case favorite_count
    }
}
