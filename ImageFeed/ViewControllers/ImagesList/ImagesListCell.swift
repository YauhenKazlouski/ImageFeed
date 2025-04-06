//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by PlAdmin on 9.02.25.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Public properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - UI Elements
    private let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func setupView() {
        [cellImage, likeButton, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setConstraints()
        
        backgroundColor = UIColor(named: "YP Black")
        selectionStyle = .none
    }
    
    // MARK: - Public functions
    func configure(image: UIImage?, dateText: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = dateText
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}

//MARK: - setConstraints
extension ImagesListCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor, constant: -8)
        ])
    }
}
