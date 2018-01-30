//
//  LinkTableViewCell.swift
//  Tumblr
//
//  Created by Alex Demchenko on 29/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }

    private let shadowView = ShadowView()

    private let linkImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "icon-link")
    }

    private let linkLabel = UILabel().then {
        $0.font = .avenirRegular(ofSize: 16)
    }

    // MARK: Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(shadowView)
        contentView.addSubview(containerView)
        containerView.addSubview(linkImageView)
        containerView.addSubview(linkLabel)

        setupConstaints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers

    func configure(link: String?) {
        linkLabel.text = link
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

        linkImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }

        linkLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(linkImageView).offset(-16)
        }
    }
}
