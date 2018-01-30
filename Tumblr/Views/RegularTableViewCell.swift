//
//  RegularTableViewCell.swift
//  Tumblr
//
//  Created by Alex Demchenko on 28/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import UIKit

class RegularTableViewCell: UITableViewCell {

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }

    private let shadowView = ShadowView()

    private let titleLabel = UILabel().then {
        $0.font = .avenirBold(ofSize: 20)
        $0.numberOfLines = 2
    }

    private let bodyLabel = UILabel().then {
        $0.font = .avenirRegular(ofSize: 16)
        $0.numberOfLines = 4
    }

    // MARK: Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(shadowView)
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bodyLabel)

        setupConstaints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers

    func configure(title: String?, body: String?) {
        titleLabel.text = title
        bodyLabel.text = body
    }

    // MARK: UI

    private func setupConstaints() {
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }

        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }

        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
