//
//  OrderDetailModel.swift
//  Splidu
//
//  Created by abdWasiq on 19/09/2022.
//

import Foundation
// MARK: - Welcome
struct OrderDetailModel: Codable {
    let status: String?
    let code: Int?
    let order: Order?
    let allGuests: [AllGuest]?
    let dining: WelcomeDining?

    enum CodingKeys: String, CodingKey {
        case status, code, order
        case allGuests = "all_guests"
        case dining
    }
}

// MARK: - AllGuest
struct AllGuest: Codable {
    let id: Int?
    let isWaiting, joining: Bool?
    let name, gender: String?
    let ownerID: Int?
    let orderStatus: String?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case id
        case isWaiting = "is_waiting"
        case joining, name, gender
        case ownerID = "owner_id"
        case orderStatus = "order_status"
        case date
    }
}

// MARK: - WelcomeDining
struct WelcomeDining: Codable {
    let id, chefID: Int?
    let eventID: Int?
    let title, slug, dateType, priceType: String?
    let startTime, endTime: String?
    let pricePerson, discountPrice: String?
    let purposeDining: String?
    let location: String?
    let seats, totalSeats, guestsBooking: Int?
    let seatExtendable: String?
    let experienceSummary, menuDescription, guidelinesInformation, logisticInformation: String?
    let policy: String?
    let status: Int?
    let cancellationPolicy: String?
    let appBannerAttachment, logisticAttachment, menuAttachment: String?
    let deletedAt: String?
    let createdAt, updatedAt, type, review: String?
    let timeStart, timeEnd, eventLocationLink: String?
    let approveStatus: Int?
    let publishDate, publishTime: String?
    let enableLocationTiming: Int?
    let customCuisine: String?
    let isRejected: Int?
    let rejectReason: String?
    let dates: [DateElement]?
    let cancels: [Cancel]?
    let cuisines: [Cuisine]?
    let allergens: [Allergen]?

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
        case dates, cuisines, allergens
        case cancels
    }
}

// MARK: - DateElement
struct DateElement: Codable {
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

// MARK: - Order
struct Order: Codable {
    let orderStatus, confirmNumber: String?
    let seats, diningID, orderID: Int?
    let total: String?
    let waiting, confirmed: Int?
    let confirmedDate: String?
    let dining: OrderDining?
    let ordermain: Ordermain?

    enum CodingKeys: String, CodingKey {
        case orderStatus = "order_status"
        case confirmNumber = "confirm_number"
        case seats
        case diningID = "dining_id"
        case orderID = "order_id"
        case total, waiting, confirmed
        case confirmedDate = "confirmed_date"
        case dining, ordermain
    }
}

// MARK: - OrderDining
struct OrderDining: Codable {
    let location, timeStart: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case location
        case timeStart = "time_start"
        case id
    }
}

// MARK: - Ordermain
struct Ordermain: Codable {
    let diningDate, time: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case diningDate = "dining_date"
        case time, id
    }
}
