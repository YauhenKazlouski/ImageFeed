//
//  ViewController.swift
//  ImageFeed
//
//  Created by PlAdmin on 23.01.25.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var presenter: ImagesListPresenterProtocol = ImagesListPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        
        setupView()
        presenter.viewDidLoad()
    }
    
    //MARK: - Public Methods
    func updateTableViewAnimated() {
        tableView.reloadData()
    }
    
    func showLikeAlert(_ error: any Error) {
        let alert = UIAlertController(
                    title: "Ошибка",
                    message: "Не удалось поставить лайк",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
    }
    
    func showImageAlert() {
        let alert = UIAlertController(
                    title: "Ошибка",
                    message: "Некорректная ссылка на изображение",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
    }
    
    func performBatchUpdates(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
                    let indexPath = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                    tableView.insertRows(at: indexPath, with: .automatic)
                } completion: { _ in }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.addSubview(tableView)
        setConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.photosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        if let photo = presenter.photo(at: indexPath.row) {
            cell.configure(with: photo, using: presenter.dateFormatter)
            cell.delegate = self
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let photo = presenter.photo(at: indexPath.row) else { return }
        guard photo.isValidLargeURL else {
            showImageAlert()
            return
        }
        
        let singleImageVC = SingleImageViewController()
        singleImageVC.imageURL = photo.largeImageURL
        singleImageVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(singleImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter.photo(at: indexPath.row) else { return 0 }
        return presenter.calculateCellHeight(for: photo, tableViewWidth: tableView.bounds.width)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.photosCount - 1 {
            presenter.fetchPhotosNextPageIfNeeded()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let photo = presenter.photo(at: indexPath.row) else { return }
        
        presenter.changeLike(for: photo.id, isLike: !photo.isLiked) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            if let newPhoto = self?.presenter.photo(at: indexPath.row) {
                                cell.setIsLiked(newPhoto.isLiked)
                            }
                        case .failure(let error):
                            self?.showLikeAlert(error)
                            cell.setIsLiked(photo.isLiked)
                        }
                    }
                }
        
    }
}

//MARK: - Constraints
extension ImagesListViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
