//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 03.04.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet private var infoLabel: UILabel!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var photoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func logoutButtonWasPressed(_ sender: Any) {
    }
    
}
