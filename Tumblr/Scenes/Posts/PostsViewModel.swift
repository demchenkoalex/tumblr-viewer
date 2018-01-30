//
//  PostsViewModel.swift
//  Tumblr
//
//  Created by Alex Demchenko on 27/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias PostSection = AnimatableSectionModel<String, Post>

struct PostsViewModel {

    let username: String
    private let postService: PostService

    // Input

    let fetchPosts = PublishRelay<Void>()

    // Output

    lazy var posts: Observable<Event<[PostSection]>> = { this in
        return fetchPosts
            .flatMapLatest {
                this.postService.fetchPosts(for: this.username)
                    .map { [PostSection(model: "", items: $0)] }
                    .timeout(10, scheduler: MainScheduler.instance)
                    .asObservable()
                    .materialize()
            }
            .share()
    }(self)

    init(username: String, postService: PostService) {
        self.username = username
        self.postService = postService
    }
}
