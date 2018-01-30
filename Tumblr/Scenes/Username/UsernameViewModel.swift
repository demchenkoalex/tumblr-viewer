//
//  UsernameViewModel.swift
//  Tumblr
//
//  Created by Alex Demchenko on 30/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import RxSwift
import RxCocoa

struct UsernameViewModel {

    // Input

    let proceed = PublishSubject<Void>()
    let username = PublishRelay<String>()

    // Output

    var postsViewModel: Observable<PostsViewModel> {
        let postService = PostService()

        return proceed
            .withLatestFrom(username)
            .filter { !$0.isEmpty }
            .map { PostsViewModel(username: $0, postService: postService) }
    }
}
