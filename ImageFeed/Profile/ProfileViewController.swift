//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by PandaPo on 12.02.25.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let userFotoImageView: UIImageView = {
        let profileImage = UIImage(named: "Photo")
        let imageView = UIImageView(image: profileImage)
        return imageView
    }()
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = .boldSystemFont(ofSize: 23)
        return label
    }()
    
    private let labelTag: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let labelStatus: UILabel = {
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
        
    }
    
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        let elementsOnView = [userFotoImageView, labelName, labelTag, labelStatus, button]
        elementsOnView.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
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
            
            labelName.leadingAnchor.constraint(equalTo: userFotoImageView.leadingAnchor),
            labelName.topAnchor.constraint(equalTo: userFotoImageView.bottomAnchor, constant: 8),
            
            labelTag.leadingAnchor.constraint(equalTo: userFotoImageView.leadingAnchor),
            labelTag.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            
            labelStatus.leadingAnchor.constraint(equalTo: userFotoImageView.leadingAnchor),
            labelStatus.topAnchor.constraint(equalTo: labelTag.bottomAnchor, constant: 8),
            
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            button.centerYAnchor.constraint(equalTo: userFotoImageView.centerYAnchor)
        ])
    }
}
