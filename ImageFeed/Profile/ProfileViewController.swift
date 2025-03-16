//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by PandaPo on 12.02.25.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private let userFotoImageView: UIImageView = {
        let profileImage = UIImage(named: "Photo")
        let imageView = UIImageView(image: profileImage)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = .boldSystemFont(ofSize: 23)
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.tintColor = .ypRed
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        updateProfileDetails()
    }
    
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        let elementsOnView = [userFotoImageView, nameLabel, loginNameLabel, descriptionLabel, button]
        elementsOnView.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func updateProfileDetails() {
        if let profile = profileService.profile {
            nameLabel.text = profile.name
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        }
    }
    
    @objc private func didTapButton() {
        // TODO: - Добавить логику при нажатии на кнопку
    }
}

extension ProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userFotoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userFotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userFotoImageView.widthAnchor.constraint(equalToConstant: 70),
            userFotoImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: userFotoImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: userFotoImageView.bottomAnchor, constant: 8),
            
            loginNameLabel.leadingAnchor.constraint(equalTo: userFotoImageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: userFotoImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            button.centerYAnchor.constraint(equalTo: userFotoImageView.centerYAnchor)
        ])
    }
}
