//
//  GitHubSearchResponse.swift
//  iOSEngineerCodeCheck
//
//  Created by 工藤海斗 on 2021/06/25.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct GitHubSearchResponse: Codable {
    let items: [Item]
}

struct Item: Codable {
    let id: Int
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case fullName = "full_name"
        case language = "language"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner = "owner"
    }
}

struct Owner: Codable {
    let avatarUrl: String

    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
