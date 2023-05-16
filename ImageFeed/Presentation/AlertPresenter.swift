//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 12.05.2023.
//

import UIKit

final class AlertPresenter {
  
  private weak var delegate: UIViewController?
  
  init(delegat: UIViewController?) {
    self.delegate = delegat
  }
  
  func showAlert(model: AlertModel) {
    let alert = UIAlertController(title: model.title,
                                  message: model.message,
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: model.buttonText,
                               style: .default,
                               handler: { _ in alert.dismiss(animated: true)})
    alert.addAction(action)
    delegate?.present(alert, animated: true, completion: nil)
  }
  
}
