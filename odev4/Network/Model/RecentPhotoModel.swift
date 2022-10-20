//
//  RecentPhotoModel.swift
//  odev4
//
//  Created by Cagla Efendioglu on 13.10.2022.
//

import Foundation

// MARK: - RecentPhoto

struct RecentPhoto: Codable {
    let photos: Photos?
}

// MARK: - Photos

struct Photos: Codable {
//    let page, pages, perpage, total: Int?
    let photo: [Photo]?
}

// MARK: - Photo

struct Photo: Codable {
    let id, owner, secret, server: String?
//    let farm: Int?
//    let title: String?
//    let ispublic, isfriend, isfamily: Int?
}
