//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Евгений Лукин on 31.05.2023.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    private var subscriptions: Set<AnyCancellable> = []
    private var isStatusBarHidden: Bool = true
    private var viewModel = ProfileViewViewModel()
    
    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.opacity = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        
        configureConstraints()
        binsViews()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retreiveUser()
    }
    
    //MARK: - binsViews
    private func binsViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            self?.headerView.displayNameLabel.text = user.displayName
            self?.headerView.usernameLabel.text = "@\(user.userName)"
            self?.headerView.followersCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.userBioLabel.text = user.bio
            self?.headerView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
            self?.headerView.joinedDateLabel.text = "Joined \(self?.viewModel.getFormattedDate(with: user.createdOn) ?? "")"
        }
        .store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.profileTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
    }
    
    //MARK: - configureConstraints
    private func configureConstraints() {
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        let tweetModel = viewModel.tweets[indexPath.row]
        cell.configureTweet(with: tweetModel.author.displayName,
                            username: tweetModel.author.userName,
                            tweetTextContent: tweetModel.tweetContent,
                            avatarPath: tweetModel.author.avatarPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            } completion: { _ in }
            
        } else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            } completion: { _ in }
        }
    }
}
