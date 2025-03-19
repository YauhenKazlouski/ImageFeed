//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by PandaPo on 01.03.25.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let logoImageView: UIImageView = {
        let logoImage = UIImage(named: "auth_screen_logo")
        let logoView = UIImageView(image: logoImage)
        return logoView
    }()
       
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.tintColor = .ypBlack
        button.backgroundColor = .ypWhite
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        [logoImageView, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    @objc private func didTapLoginButton() {
        let webVC = WebViewViewController()
        webVC.delegate = self
        let navigationController = UINavigationController(rootViewController: webVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        UIBlocingProgressHUD.show()
        
        OAuth2Servise.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            
            UIBlocingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                print("Токен получен и сохранен: \(token)")
                
                self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                self.dismiss(animated: true)
                
            case .failure(let error):
                print("[webViewViewController]: Ошибка авторизации: \(error.localizedDescription)")
                self.showErrorAlert(message: "Не удалось войти в систему")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Constraints
extension AuthViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -124),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
