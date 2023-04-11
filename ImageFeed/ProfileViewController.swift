//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 03.04.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let avatarImage = UIImageView()
    private let buttonLogout = UIButton()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAvatarImage()
        createButtonLogout()
        createNameLabel()
        createUsernameLabel()
        createDescriptionLabel()
    }

    private func createAvatarImage() {
        avatarImage.image = UIImage(named: "Photo")
        view.addSubview(avatarImage)
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func createButtonLogout() {
        buttonLogout.setImage(UIImage(named: "ipad.and.arrow.forward"), for: .normal)
        buttonLogout.addTarget(self, action: #selector(logoutButtonWasPressed), for: .touchUpInside)
        view.addSubview(buttonLogout)
        
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonLogout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            buttonLogout.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            buttonLogout.widthAnchor.constraint(equalToConstant: 20),
            buttonLogout.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func createNameLabel() {
        nameLabel.font = UIFont(name: "SFPro-Bold", size: 23)
        nameLabel.textColor = UIColor(named: "YP White (iOS)")
        nameLabel.text = "Екатерина Новикова"
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    private func createUsernameLabel() {
        usernameLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        usernameLabel.textColor = UIColor(named: "YP Gray (iOS)")
        usernameLabel.text = "@ekaterina_nov"
        view.addSubview(usernameLabel)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func createDescriptionLabel() {
        descriptionLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        descriptionLabel.textColor = UIColor(named: "YP White (iOS)")
        descriptionLabel.text = "Hello, world!"
        view.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func logoutButtonWasPressed(_ sender: Any) {
        print("logoutButtonWasPressed")
    }
    
    
    
}
