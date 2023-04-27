//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 25.04.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreenSegueIdentifier = "AuthenticationScreen"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage().token {
            switchToTabBarController()
        }  else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let vc = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")}
            vc.delegate = self
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
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController?, didAuthenticateWithCode code: String) {
        switchToTabBarController()
    }
    
}
