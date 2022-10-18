//
//  WalletModel.swift
//  Splidu
//
//  Created by Wasiq Saleem on 24/09/2022.
//

import Foundation

// MARK: - MyWalletModel
struct MyWalletModel: Codable {
    let code: Int?
    let status: String?
    let data: MyWalletData?
    let lastTransaction: LastTransaction?

    enum CodingKeys: String, CodingKey {
        case code, status, data
        case lastTransaction = "last_transaction"
    }
}

// MARK: - DataClass
struct MyWalletData: Codable {
    let id: Int?
    let walletID: String?
    let wallet: Wallet?

    enum CodingKeys: String, CodingKey {
        case id
        case walletID = "wallet_id"
        case wallet
    }
}

// MARK: - Wallet
struct Wallet: Codable {
    let id, userID: Int?
    let balance, createdAt, updatedAt: String?
    let history: [LastTransaction]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case balance
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case history
    }
}

// MARK: - LastTransaction
struct LastTransaction: Codable {
    let id, walletID: Int?
    let transactionType: TransactionType?
    let amount, lastTransactionDescription, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case walletID = "wallet_id"
        case transactionType = "transaction_type"
        case amount
        case lastTransactionDescription = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum TransactionType: String, Codable {
    case credit = "credit"
    case debit = "debit"
}
