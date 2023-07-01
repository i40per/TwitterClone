//
//  Tweet.swift
//  TwitterClone
//
//  Created by Евгений Лукин on 25.06.2023.
//

import Foundation

struct Tweet: Codable {
    var id = UUID().uuidString
    let author: TwitterUser
    let authorID: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    var createTweetDate: Date = Date()
    let parentReference: String?
}
