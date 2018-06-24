//
//  ReferenceEnums.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-03.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

enum DatabaseReference: String {
    case users = "users"
    case username = "username"
    case memberSince = "meberSince"
    case posts = "posts"
    case imageUrl = "imageUrl"
    case date = "date"
    case challengeDate = "challengeDate"
    case admin = "admin"
    case challenges = "challenges"
    case challengeDescription = "challengeDescription"
    case startDate = "startDate"
    case ratings = "ratings"
    case participants = "participants"
    case allTimeVotes = "allTimeVotes"
    case monthVotes = "monthVotes"
    case votes = "votes"
    case userVotes = "userVotes"
    case profileDeleteDate = "profileDeleteDate"
    case profilePicURL = "profilePicURL"
    case profilePics = "profilePics"
    case isOnBoarded = "isOnBoarded"
}

enum NotificationNames: String {
    case postProfileComplete = "postProfileComplete"
    case postVoteComplete = "postVoteComplete"
}
