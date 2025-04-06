//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by PlAdmin on 9.02.25.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    private let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .ypBackground
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(likeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .ypWhite
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
    
    // MARK: - Private functions
    private func setupView() {
        [cellImage, likeButton, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setConstraints()
        
        backgroundColor = .ypBlack
        selectionStyle = .none
    }
    
    @objc private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Public functions
    func configure(with photo: Photo, using dateFormatter: DateFormatter) {
        dateLabel.text = photo.createAt.map { dateFormatter.string(from: $0) } ?? ""
        setIsLiked(photo.isLiked)
        
        if let url = URL(string: photo.thumbImageURL) {
            cellImage.kf.setImage(with: url,
                                  placeholder: UIImage(named: "placeholderImage"),
                                  options: [.transition(.fade(0.2))])
        }
    }
    
    func setIsLiked(_ isLiked: Bool) {
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
