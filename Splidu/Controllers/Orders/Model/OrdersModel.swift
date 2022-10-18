//
//  OrdersModel.swift
//  Splidu
//
//  Created by Wasiq Saleem on 16/09/2022.
//

import Foundation
// MARK: - OrdersModel
struct OrdersModel: Codable {
    let status: String?
    let code: Int?
    let orders: [Orders]?
}

// MARK: - Orders
struct Orders: Codable {
    let type: String?
    let orders: [OrderDetails]?
}

// MARK: - OrderOrder
struct OrderDetails: Codable {
    let pricePerson, orderStatus, confirmNumber: String?
    let seats, diningID, orderID: Int?
    let total: String?
    let waiting, confirmed: Int?
    let dining: OrdersDining?
    let ordermain: OrderMain?

    enum CodingKeys: String, CodingKey {
        case pricePerson = "price_person"
        case orderStatus = "order_status"
        case confirmNumber = "confirm_number"
        case seats
        case diningID = "dining_id"
        case orderID = "order_id"
        case total, waiting, confirmed, dining, ordermain
    }
}

// MARK: - Dining
struct OrdersDining: Codable {
    let location, timeStart: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case location
        case timeStart = "time_start"
        case id
    }
}

// MARK: - Ordermain
struct OrderMain: Codable {
    let diningDate, time: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case diningDate = "dining_date"
        case time, id
    }
}
