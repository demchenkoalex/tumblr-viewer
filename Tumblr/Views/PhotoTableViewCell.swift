//
//  PhotoTableViewCell.swift
//  Tumblr
//
//  Created by Alex Demchenko on 28/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import SnapKit
import Kingfisher

class PhotoTableViewCell: UITableViewCell {

    var captionLabelTopConstraint: Constraint?
    var captionLabelBottomConstraint: Constraint?

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }

    private let shadowView = ShadowView()

    private let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let captionLabel = UILabel().then {
        $0.font = .avenirRegular(ofSize: 16)
        $0.numberOfLines = 2
    }

    // MARK: Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(shadowView)
        contentView.addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(captionLabel)

        setupConstaints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers

    func configure(photoUrl: URL?, caption: String?) {
        if let photoUrl = photoUrl {
            photoImageView.kf.setImage(with: photoUrl)
        } else {
            photoImageView.image = nil
        }

        if let caption = caption, !caption.isEmpty {
            captionLabel.text = caption
            captionLabelTopConstraint?.update(offset: 16)
            captionLabelBottomConstraint?.update(offset: -16)
        } else {
            captionLabel.text = nil
            captionLabelTopConstraint?.update(offset: 0)
            captionLabelBottomConstraint?.update(offset: 0)
        }
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

        photoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(240).priority(.high)
        }

        captionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            self.captionLabelTopConstraint = make.top.equalTo(photoImageView.snp.bottom).offset(16).constraint
            self.captionLabelBottomConstraint = make.bottom.equalToSuperview().offset(-16).constraint
        }
    }
}
