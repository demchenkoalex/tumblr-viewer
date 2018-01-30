//
//  Post.swift
//  Tumblr
//
//  Created by Alex Demchenko on 27/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import RxDataSources

struct Post {
    let id: String
    let type: PostType
}

extension Post: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case title = "regular-title"
        case body = "regular-body"
        case caption = "photo-caption"
        case photoUrl = "photo-url-1280"
        case linkUrl = "link-url"
        case linkText = "link-text"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // For some reason Tumblr sometimes returns `id` as String and sometimes as Int ¯\_(ツ)_/¯
        let stringId = try? container.decode(String.self, forKey: .id)
        let intId = try? container.decode(Int.self, forKey: .id)
        let id = stringId ?? "\(intId ?? 0)"

        let type = try container.decode(String.self, forKey: .type)
        let title = try container.decodeIfPresent(String.self, forKey: .title)
        let body = try container.decodeIfPresent(String.self, forKey: .body)
        let caption = try container.decodeIfPresent(String.self, forKey: .caption)
        let photoUrl = try container.decodeIfPresent(URL.self, forKey: .photoUrl)
        let linkUrl = try container.decodeIfPresent(URL.self, forKey: .linkUrl)
        let linkText = try container.decodeIfPresent(String.self, forKey: .linkText)

        switch type {
        case "regular":
            self.init(id: id, type: PostType.regular(title: title, body: body))
        case "photo":
            self.init(id: id, type: PostType.photo(url: photoUrl, caption: caption))
        case "link":
            self.init(id: id, type: PostType.link(url: linkUrl, text: linkText))
        default:
            self.init(id: id, type: PostType.other)
        }
    }
}

extension Post: IdentifiableType {
    typealias Identity = String

    var identity: String {
        return id
    }
}

extension Post: Equatable {
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
