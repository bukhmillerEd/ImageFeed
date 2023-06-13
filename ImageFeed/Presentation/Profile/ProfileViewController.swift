//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 03.04.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? {get set}
    
    func updateProfileDetails(with profile: Profile)
    func updateAvatar(with url: URL)
    func clearWindowStack()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    private let avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.image = UIImage(named: "Photo")
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private let logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "ipad.and.arrow.forward"), for: .normal)
        logoutButton.addTarget(nil, action: #selector(logoutButtonWasPressed), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.accessibilityIdentifier = "logout button"
        return logoutButton
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "SFPro-Bold", size: 23)
        nameLabel.textColor = UIColor(named: "YP White (iOS)")
        nameLabel.text = "Екатерина Новикова"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        usernameLabel.textColor = UIColor(named: "YP Gray (iOS)")
        usernameLabel.text = "@ekaterina_nov"
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        return usernameLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        descriptionLabel.textColor = UIColor(named: "YP White (iOS)")
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    var presenter: ProfilePresenterProtocol? = ProfileViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        
        addSubview()
        applyConstraints()

        configure(presenter)
        presenter?.viewDidLoad()
    }
    
    func updateProfileDetails(with profile: Profile) {
        nameLabel.text = profile.name
        usernameLabel.text = profile.username
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatar(with url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        avatarImage.kf.setImage(with: url, options: [.processor(processor)])
    }
    
    private func addSubview() {
        view.addSubview(avatarImage)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(descriptionLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 22),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            usernameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func clearWindowStack() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid configuration")
        }
        let vc = SplashViewController()
        window.rootViewController = vc
    }
    
    @objc private func logoutButtonWasPressed(_ sender: Any) {
        let question = UIAlertController(title: "Пока, пока!",
                                         message: "Уверены что хотите выйти?",
                                         preferredStyle: .alert)
        let yes = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter?.removeUserData()
        }
        let no = UIAlertAction(title: "Нет", style: .default)
        question.addAction(yes)
        question.addAction(no)
        self.present(question, animated: true)
    }
    
    func configure(_ presenter: ProfilePresenterProtocol?) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
}
