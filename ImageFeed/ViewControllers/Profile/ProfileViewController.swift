//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by PandaPo on 12.02.25.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    // MARK: - Private Properties
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        nameLabel.textColor = .ypWhite
        return nameLabel
    }()
    
    private let loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = .systemFont(ofSize: 13)
        loginNameLabel.textColor = .ypGray
        return loginNameLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .ypWhite
        return descriptionLabel
    }()
    
    private lazy var imageView: UIImageView = {
        let profileImage = UIImage(named: "Photo")
        let imageView = UIImageView(image: profileImage)
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutImage = UIImage(named: "Exit")
        let logoutButton = UIButton(type: .system)
        logoutButton.setImage(logoutImage, for: .normal)
        logoutButton.tintColor = .ypRed
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        return logoutButton
    }()
    
    private var presenter: ProfilePresenterProtocol?
  
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        setupView()
        
        presenter = ProfilePresenter()
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Public Methods
    
    func updateProfileDetails(name: String, loginName: String, bio: String) {
        nameLabel.text = name
        loginNameLabel.text = loginName
        descriptionLabel.text = bio
    }
    
    func updateAvatar(with url: URL) {
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderAvatar"),
            options: [
                .transition(.fade(0.2)),
                .processor(DownsamplingImageProcessor(size: CGSize(width: 140, height: 140)))
            ]
        )
    }
    
    func showDefaultAvatar() {
        imageView.image = UIImage(named: "placeholderAvatar")
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter?.didTapLogoutButton()
        })
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Private methods
    private func setupView() {
        [imageView, nameLabel, loginNameLabel, descriptionLabel, logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setConstraints()
    }
    
    // MARK: - Actions
    @objc private func didTapLogoutButton() {
        showLogoutAlert()
    }
}

//MARK: - Constraints
extension ProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            loginNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
