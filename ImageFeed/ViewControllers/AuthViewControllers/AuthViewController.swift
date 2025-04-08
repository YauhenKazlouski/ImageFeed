//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by PandaPo on 01.03.25.
//

import UIKit
import ProgressHUD


final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    private let oauth2Service = OAuth2Service.shared
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "auth_screen_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypBlack, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        [logoImageView, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
            self.didTapLoginButton()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    @objc private func didTapLoginButton() {
        let webViewViewController = WebViewViewController()
        let webViewPresenter = WebViewPresenter()
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        
        webViewViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: webViewViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        UIBlocingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code) { [weak self] (result: Result<String, Error>) in
            guard let self = self else { return }
            
            UIBlocingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                self.delegate?.authViewController(self, didAuthenticateWithCode: token)
                
            case .failure(let error):
                print("[webViewViewController]: Ошибка авторизации - \(error.localizedDescription)")
                self.showErrorAlert(message: "Не удалось войти в систему")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

//MARK: - Constraints
extension AuthViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
