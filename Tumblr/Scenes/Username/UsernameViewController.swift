//
//  UsernameViewController.swift
//  Tumblr
//
//  Created by Alex Demchenko on 30/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import Then
import SnapKit
import RxSwift

class UsernameViewController: UIViewController {

    private let bag = DisposeBag()
    private let viewModel: UsernameViewModel

    private let yourUsernameLabel = UILabel().then {
        $0.font = .avenirBold(ofSize: 14)
        $0.text = "Tumblr username"
    }

    private let usernameTextField = UITextField().then {
        $0.font = .avenirRegular(ofSize: 20)
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.placeholder = "johnappleseed"
        $0.returnKeyType = .go
        $0.enablesReturnKeyAutomatically = true
    }

    // MARK: Initialization

    init(viewModel: UsernameViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        view.addSubview(yourUsernameLabel)
        view.addSubview(usernameTextField)

        setupConstraints()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: Rx

    private func setupBindings() {
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: bag)

        usernameTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(to: viewModel.proceed)
            .disposed(by: bag)

        viewModel.postsViewModel
            .subscribe(onNext: { viewModel in
                let postsViewController = PostsViewController(viewModel: viewModel)

                self.usernameTextField.text = nil
                self.show(postsViewController, sender: nil)
            })
            .disposed(by: bag)
    }

    // MARK: UI

    private func setupConstraints() {
        yourUsernameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-96)
            make.left.equalToSuperview().offset(16)
        }

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(yourUsernameLabel.snp.bottom).offset(8)
            make.left.equalTo(yourUsernameLabel)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
