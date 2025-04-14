//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by PandaPo on 12.02.25.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    // MARK: - Public Properties
    var imageURL: String? {
        didSet{
            guard isViewLoaded else { return }
            loadImage()
        }
    }
    
    // MARK: - Private Properties
    private var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            updateImage(image)
        }
    }
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var shareButton: UIButton = {
        let shareImage = UIImage(named: "sharing_button")
        let shareButton = UIButton(type: .custom)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return shareButton
    }()
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadInitialContent()
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(shareButton)
        
        [scrollView, imageView, shareButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setConstraints()
    }
    
    private func updateImage(_ image: UIImage) {
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
        hideShareButton()
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        guard imageSize.width > 0, imageSize.height > 0 else {
            print("[rescaleAndCenterImageInScrollView]: Ошибка - ширина или высота изображения равна нулю")
            return
        }
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(hScale, vScale)
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        updateInsets(for: scrollView)
    }
    
    private func updateInsets(for scrollView: UIScrollView) {
        let boundsSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize
        
        let verticalInset = max((boundsSize.height - contentSize.height) / 2, 0)
        let horizontalInset = max((boundsSize.width - contentSize.width) / 2, 0)
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
    
    private func hideShareButton() {
        shareButton.isHidden = image == nil
    }
    
    private func setupNavigationBar() {
        let backButtonImage = UIImage(named: "nav_back_button")
        let backButton = UIBarButtonItem(
            image: backButtonImage,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        backButton.accessibilityIdentifier = AccessibilityIds.backButton
        navigationItem.leftBarButtonItem = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func loadImage() {
        guard let imageURL, let url = URL(string: imageURL) else { return }
        let placeholderImage = UIImage(named: "placeholderImage")
        imageView.contentMode = .center
        
        UIBlocingProgressHUD.show()
        
        imageView.kf.setImage(with: url,
                              placeholder: placeholderImage,
                              options: [.transition(.fade(0.2))]) { [weak self] result in
            UIBlocingProgressHUD.dismiss()
            
            guard let self else { return }
            switch result {
            case .success(let imageURL):
                imageView.contentMode = .scaleAspectFill
                self.image = imageURL.image
                self.rescaleAndCenterImageInScrollView(image: imageURL.image)
            case .failure(let error):
                print("[loadImage]: Ошибка при загрузке \(error.localizedDescription)")
            }
            self.hideShareButton()
        }
    }
    
    private func loadInitialContent() {
        if let image {
            updateImage(image)
        } else if imageURL != nil {
            loadImage()
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapShareButton() {
        guard let image = image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        updateInsets(for: scrollView)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension SingleImageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

//MARK: - Constraints
extension SingleImageViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
