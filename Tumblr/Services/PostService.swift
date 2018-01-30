//
//  PostService.swift
//  Tumblr
//
//  Created by Alex Demchenko on 30/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import RxSwift

struct PostService {
    func fetchPosts(for username: String) -> Single<[Post]> {
        // Should be paginated but oh well.. played to much with designs ¯\_(ツ)_/¯
        return Network.request(target: .posts(username: username))
            .map([Post].self, atKeyPath: "posts")
            .map { posts in
                // Filter out all posts with type `other`
                let filteredPosts = posts.filter { post in
                    if case PostType.other = post.type {
                        return false
                    }

                    return true
                }

                return filteredPosts
            }
    }
}
