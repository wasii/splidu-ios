//
//  CMSPageModel.swift
//  Splidu
//
//  Created by Wasiq Saleem on 16/09/2022.
//

import Foundation
// MARK: - Welcome
struct CMSPagesModel: Codable {
    let code: Int?
    let status: String?
    let data: CMSPageDetail?
}

// MARK: - DataClass
struct CMSPageDetail: Codable {
    let titleEn, titleAr: String?
    let status: Int?
    let descEn, descAr: String?
    let metaTitle, metaKeyword, metaDescription: String?
    let createdAt, updatedAt: String?
    let id: Int?
    let slug: String?

    enum CodingKeys: String, CodingKey {
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case status
        case descEn = "desc_en"
        case descAr = "desc_ar"
        case metaTitle = "meta_title"
        case metaKeyword = "meta_keyword"
        case metaDescription = "meta_description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id, slug
    }
}
