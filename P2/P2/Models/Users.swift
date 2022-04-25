//
//  Users.swift
//  P2
//
//  Created by Zahraa Herz on 31/03/2022.
//

//
//  User.swift
//  P2
//
//  Created by Zahraa Herz on 31/03/2022.
//

import Foundation

struct Users: Codable {
    let page : Int?
    let per_page : Int?
    let total : Int?
    let total_pages : Int?
    let data : [User]?
    let support : Support?

    enum CodingKeys: String, CodingKey {

        case page = "page"
        case per_page = "per_page"
        case total = "total"
        case total_pages = "total_pages"
        case data = "data"
        case support = "support"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
        data = try values.decodeIfPresent([User].self, forKey: .data)
        support = try values.decodeIfPresent(Support.self, forKey: .support)
    }

}





