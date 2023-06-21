//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 18.04.2023.
//

import UIKit

protocol WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController?, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let sequeId =  "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    private var alertPresenter: AlertPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegat: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == sequeId {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(sequeId)")
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.navigationDelegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchAuthToken(code: code) { [weak self] result in
            switch result {
            case .success(let bearerToken):
                OAuth2TokenStorage.shared.token = bearerToken
                DispatchQueue.main.async {
                    self?.delegate?.authViewController(self, didAuthenticateWithCode: code)
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure:
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self?.alertPresenter?.showAlert(
                        model: AlertModel(
                            title: "Что-то пошло не так(",
                            message: "Не удалось войти в систему. Ошибка при получении токена",
                            buttonText: "Ok")
                    )
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
}
