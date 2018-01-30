//
//  PostsViewController.swift
//  Tumblr
//
//  Created by Alex Demchenko on 27/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import RxSwift
import RxSwiftExt
import Kingfisher
import RxDataSources
import SafariServices
import SimpleImageViewer

class PostsViewController: UIViewController {

    private let bag = DisposeBag()
    private var viewModel: PostsViewModel
    private var dataSource: RxTableViewSectionedAnimatedDataSource<PostSection>!

    private let tableView = UITableView().then {
        $0.register(RegularTableViewCell.self, forCellReuseIdentifier: "regularCell")
        $0.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photoCell")
        $0.register(LinkTableViewCell.self, forCellReuseIdentifier: "linkCell")
        $0.rowHeight = UITableViewAutomaticDimension
        $0.backgroundColor = .background
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
    }

    private let tableViewEmptyLabel = UILabel().then {
        $0.text = "No Posts"
        $0.textColor = .darkGray
        $0.font = .avenirRegular(ofSize: 20)
        $0.textAlignment = .center
    }

    private let refreshControl = UIRefreshControl()

    // MARK: Initialization

    init(viewModel: PostsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)

        setupConstraints()
        setupDataSource()
        setupBindings()

        // Reveal refresh control
        tableView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        refreshControl.beginRefreshing()
    }

    // MARK: Rx

    private func setupDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<PostSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch item.type {
                case let .regular(title, body):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "regularCell", for: indexPath) as! RegularTableViewCell
                    cell.configure(title: title, body: body)

                    return cell
                case let .photo(url, caption):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
                    cell.configure(photoUrl: url, caption: caption)

                    return cell
                case let .link(_, text):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath) as! LinkTableViewCell
                    cell.configure(link: text)

                    return cell
                case .other:
                    // Because we filter out all `.other` posts in view model we can not hit this case
                    return UITableViewCell()
                }
        })
    }

    private func setupBindings() {

        // Bind posts to `UITableView`
        viewModel.posts
            .elements()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        // Display empty state if posts array is empty
        viewModel.posts
            .elements()
            .subscribe(onNext: { [weak self] sections in
                guard let firstSection = sections.first else { return }

                self?.tableView.backgroundView = firstSection.items.isEmpty ? self?.tableViewEmptyLabel : nil
            })
            .disposed(by: bag)

        // Display error message
        viewModel.posts
            .errors()
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let message = !error.localizedDescription.isEmpty ?
                    error.localizedDescription :
                    "Something went wrong"

                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))

                self?.present(alertController, animated: true)
            })
            .disposed(by: bag)

        // Set `isRefreshing` to false after successful response or error
        Observable.of(
                viewModel.posts.elements().map { _ in false },
                viewModel.posts.errors().map { _ in false }
            )
            .merge()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: bag)

        // Fetch once on `viewDidAppear` and every time `UIRefreshControl` gets triggered
        Observable.of(
                rx.sentMessage(#selector(PostsViewController.viewDidAppear(_:)))
                    .map { _ in }
                    .take(1),
                refreshControl.rx.controlEvent(.valueChanged)
                    .asObservable()
            )
            .merge()
            .bind(to: viewModel.fetchPosts)
            .disposed(by: bag)

        // Delegate to add header
        tableView.rx.setDelegate(self)
            .disposed(by: bag)

        // Cell selection handling
        tableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { [weak self] post in
                switch post.type {
                case let .regular(title, body):
                    let regularPostDetailsViewController = RegularPostDetailsViewController(title: title, body: body)

                    self?.show(regularPostDetailsViewController, sender: nil)
                case let .photo(url, _):
                    guard let url = url else { return }

                    ImageCache.default.retrieveImage(forKey: url.absoluteString, options: nil) { image, _ in
                        guard let image = image else { return }

                        let configuration = ImageViewerConfiguration { config in
                            config.image = image
                        }

                        let imageViewController = ImageViewerController(configuration: configuration)

                        self?.present(imageViewController, animated: true)
                    }
                case let .link(url, _):
                    guard let url = url else { return }

                    let safariViewController = SFSafariViewController(url: url)
                    safariViewController.preferredControlTintColor = .darkGray

                    self?.present(safariViewController, animated: true)
                case .other:
                    return
                }
            })
            .disposed(by: bag)
    }

    // MARK: UI

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
}

