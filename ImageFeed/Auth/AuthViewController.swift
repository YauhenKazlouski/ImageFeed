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
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        configureBackButton()
        configureLoginButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            if let webViewViewController = segue.destination as? WebViewViewController {
                webViewViewController.delegate = self
            } else {
                print("[prepare]: Ошибка не удалось привести segue.destination к типу WebViewViewController")
                navigationController?.popViewController(animated: true)
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        [logoImageView, loginButton].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0!)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func configureLoginButton() {
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 17)
        loginButton.tintColor = .ypBlack
        loginButton.backgroundColor = .ypWhite
        loginButton.layer.cornerRadius = 16
        loginButton.layer.masksToBounds = true
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
