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
        if segue.identifier == sequeId,
           let vc = segue.destination as? WebViewViewController {
            vc.navigationDelegate = self
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        DispatchQueue.main.async {
            OAuth2Service.shared.fetchAuthToken(code: code) { [weak self] result in
                switch result {
                case .success(let bearerToken):
                    OAuth2TokenStorage().token = bearerToken
                    self?.delegate?.authViewController(self, didAuthenticateWithCode: code)
                    UIBlockingProgressHUD.dismiss()
                case .failure(_):
                    UIBlockingProgressHUD.dismiss()
                    DispatchQueue.main.async {
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
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        UIBlockingProgressHUD.show()
        vc.dismiss(animated: true)
    }
    
}
