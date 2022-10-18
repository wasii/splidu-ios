//
//  HomeChefDetailModel.swift
//  Splidu
//
//  Created by Wasiq Saleem on 16/09/2022.
//

import Foundation
// MARK: - HomeChefDetailModel
struct HomeChefDetailModel: Codable {
    let baseURL: String?
    let status: String?
    let code: Int?
    let dates: [HomeChefDetailDates]?
    let months: [String]?
    let time: String?
    let totalSeats: Int?
    let filledSlots: Int?
    let availableSlots, unknownSeats: Int?
    var wBalance: String?
    var vatTax: String?
    var dining: HomeChefDining?

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case status, code, dates, months, time
        case totalSeats = "total_seats"
        case filledSlots = "filled_slots"
        case availableSlots = "available_slots"
        case unknownSeats = "unknown_seats"
        case wBalance = "wallet_balance"
        case vatTax = "vat_tax"
        case dining
    }
}

// MARK: - HomeChefDetailDates
struct HomeChefDetailDates: Codable {
    let dates, days, month: String?
    var isSelected: Bool?
}

// MARK: - HomeChefDining
struct HomeChefDining: Codable {
    let id, chefID: Int?
    let eventID: Int?
    let title, slug, dateType, priceType: String?
    let startTime, endTime, pricePerson, discountPrice: String?
    let purposeDining: String?
    let location: String?
    let seats, totalSeats, guestsBooking: Int?
    let seatExtendable: String?
    let experienceSummary, menuDescription, guidelinesInformation, logisticInformation: String?
    let policy: String?
    let status: Int?
    let cancellationPolicy, appBannerAttachment, logisticAttachment, menuAttachment: String?
    let deletedAt: String?
    let createdAt, updatedAt, type, review: String?
    let timeStart, timeEnd, eventLocationLink: String?
    let approveStatus: Int?
    let publishDate, publishTime: String?
    let enableLocationTiming: Int?
    let customCuisine: String?
    let isRejected: Int?
    let rejectReason: String?
    let dates: [DiningDate]?
    let allergens: [Allergen]?
    let cuisines: [Cuisine]?
    let cancels: [Cancel]?
    let gallery: [Gallery]?
    var finalPrice: String?

    enum CodingKeys: String, CodingKey {
        case id
        case chefID = "chef_id"
        case eventID = "event_id"
        case title, slug
        case dateType = "date_type"
        case priceType = "price_type"
        case startTime = "start_time"
        case endTime = "end_time"
        case pricePerson = "price_person"
        case discountPrice = "discount_price"
        case purposeDining = "purpose_dining"
        case location, seats
        case totalSeats = "total_seats"
        case guestsBooking = "guests_booking"
        case seatExtendable = "seat_extendable"
        case experienceSummary = "experience_summary"
        case menuDescription = "menu_description"
        case guidelinesInformation = "guidelines_information"
        case logisticInformation = "logistic_information"
        case policy, status
        case cancellationPolicy = "cancellation_policy"
        case appBannerAttachment = "app_banner_attachment"
        case logisticAttachment = "logistic_attachment"
        case menuAttachment = "menu_attachment"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case type, review
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case eventLocationLink = "event_location_link"
        case approveStatus = "approve_status"
        case publishDate = "publish_date"
        case publishTime = "publish_time"
        case enableLocationTiming = "enable_location_timing"
        case customCuisine = "custom_cuisine"
        case isRejected = "is_rejected"
        case rejectReason = "reject_reason"
        case dates, allergens, cuisines, cancels, gallery
        case finalPrice
    }
}

// MARK: - Allergen
struct Allergen: Codable {
    let id: Int?
    let title, file: String?
    let status: Int?
    let deletedAt: String?
    let createdAt, updatedAt: String?
    let pivot: AllergenPivot?

    enum CodingKeys: String, CodingKey {
        case id, title, file, status
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pivot
    }
}

// MARK: - AllergenPivot
struct AllergenPivot: Codable {
    let diningID, allergenID: Int?

    enum CodingKeys: String, CodingKey {
        case diningID = "dining_id"
        case allergenID = "allergen_id"
    }
}

// MARK: - Cancel
struct Cancel: Codable {
    let id, diningID, hours: Int?
    let refund: String?
    let deletedAt: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case diningID = "dining_id"
        case hours, refund
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Cuisine
struct Cuisine: Codable {
    let id: Int?
    let title: String?
    let deletedAt: String?
    let createdAt, updatedAt: String?
    let status: Int?
    let pivot: CuisinePivot?

    enum CodingKeys: String, CodingKey {
        case id, title
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status, pivot
    }
}

// MARK: - CuisinePivot
struct CuisinePivot: Codable {
    let diningID, cuisineID: Int?

    enum CodingKeys: String, CodingKey {
        case diningID = "dining_id"
        case cuisineID = "cuisine_id"
    }
}

// MARK: - DiningDate
struct DiningDate: Codable {
    let id, diningID: Int?
    let date: String?
    let deletedAt: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case diningID = "dining_id"
        case date
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Gallery
struct Gallery: Codable {
    let id, diningID: Int?
    let image: String?
    let masterStatus: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case diningID = "dining_id"
        case image
        case masterStatus = "master_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//MARK: Get Seats from date selection
struct GetSeatsFromDates: Codable {
    let baseURL: String?
    let status: String?
    let code, totalSeats, filledSlots, availableSlots: Int?
    let unknownSeats: Int?

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case status, code
        case totalSeats = "total_seats"
        case filledSlots = "filled_slots"
        case availableSlots = "available_slots"
        case unknownSeats = "unknown_seats"
    }
}

// MARK: - Stripe Data
struct StripeApiResponse: Codable {
    let transactionID: String
    let paymentRefrence: String
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case paymentRefrence = "payment_ref"
    }
}
