//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 25.04.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreenSegueIdentifier = "AuthenticationScreen"
    private let profileService = ProfileService.shared
    private var alertPresenter: AlertPresenter?
    private var splashLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_screen_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP black")
        alertPresenter = AlertPresenter(delegat: self)
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(splashLogo)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            splashLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashLogo.widthAnchor.constraint(equalToConstant: 77.68),
            splashLogo.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let token = OAuth2TokenStorage.shared.token
        if let token  {
            fetchProfile()
        }  else {
            let sb = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = sb.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        DispatchQueue.main.async {
            // Получим экземпляр Window приложения
            guard let window = UIApplication.shared.windows.first else {
                fatalError("Invalid configuration")
            }
            // Создаем экземпляр нужного контроллера из сториборда
            let sb = UIStoryboard(name: "Main", bundle: .main)
            let tabBarVC = sb.instantiateViewController(withIdentifier: "TabBarViewController")
            window.rootViewController = tabBarVC
        }
    }
    
    private func fetchProfile() {
        //guard let token = OAuth2TokenStorage.shared.token else { return }
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile() { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self?.alertPresenter?.showAlert(
                        model: AlertModel(title: "Что-то пошло не так(",
                                          message: "Не удалось войти в систему» и кнопкой. Ошибка при получении данных профиля",
                                          buttonText: "Ok")
                    )
                }
            case .success(let profileResult):
                ProfileImageService.shared.fetchProfileImageURL(username: profileResult.username) { result in
                    switch result {
                    case.failure:
                        DispatchQueue.main.async {
                            UIBlockingProgressHUD.dismiss()
                            self?.alertPresenter?.showAlert(
                                model: AlertModel(title: "Что-то пошло не так(",
                                                  message: "Не удалось войти в систему» и кнопкой. Ошибка при получении аватарки",
                                                  buttonText: "Ok"))
                        }
                    case.success:
                        DispatchQueue.main.async {
                            UIBlockingProgressHUD.dismiss()
                            self?.switchToTabBarController()
                        }
                    }
                }
            }
        }
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController?, didAuthenticateWithCode code: String) {
        fetchProfile()
        switchToTabBarController()
    }
    
}
