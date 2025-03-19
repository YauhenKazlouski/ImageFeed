//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by PandaPo on 02.03.25.
//

import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oauth2Service = OAuth2Servise.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    
    private let splashImageView: UIImageView = {
        let splashImage = UIImage(named: "Vector")
        let imageView = UIImageView(image: splashImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        view.addSubview(splashImageView)
        setConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            fetchProfile()
        } else {
            
            let authViewController = AuthViewController()
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile() {
        UIBlocingProgressHUD.show()
        
        profileService.fetchProfile { [weak self] result in
            UIBlocingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    let username = profile.username
                    ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in }
                    self.switchToTabBarController()
                case .failure:
                    // TODO: Обработка ошибки загрузки профиля
                    print("Ошибка загрузки профиля")
                }
            }
        }
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.fetchProfile()
            case .failure:
                // TODO [Sprint 11]
                break
            }
        }
    }
}

extension SplashViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            splashImageView.widthAnchor.constraint(equalToConstant: 75),
            splashImageView.heightAnchor.constraint(equalToConstant: 78)
        ])
    }
}

