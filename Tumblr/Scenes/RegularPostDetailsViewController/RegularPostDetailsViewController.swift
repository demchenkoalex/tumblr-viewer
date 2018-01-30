//
//  RegularPostDetailsViewController.swift
//  Tumblr
//
//  Created by Alex Demchenko on 30/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import UIKit

class RegularPostDetailsViewController: UIViewController {

    private let titleLabel = UILabel().then {
        $0.font = .avenirBold(ofSize: 20)
        $0.numberOfLines = 0
    }

    private let bodyTextView = UITextView().then {
        $0.font = .avenirRegular(ofSize: 16)
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: Initialization

    init(title: String?, body: String?) {
        titleLabel.text = title
        bodyTextView.text = body

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        view.addSubview(titleLabel)
        view.addSubview(bodyTextView)

        setupConstraints()
    }

    // MARK: Helpers

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Fix `UITextView` offset when view controller is presented
        bodyTextView.setContentOffset(.zero, animated: false)
    }

    // MARK: UI

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }

        let isTitleAvailable = titleLabel.text != nil && !titleLabel.text!.isEmpty

        bodyTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(isTitleAvailable ? 8 : 0)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
