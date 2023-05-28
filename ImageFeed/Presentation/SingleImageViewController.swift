//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 04.04.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {

    private var alertPresenter: AlertPresenter?
    private var image: UIImage?
    var imageUrl: String = String()
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        fetchImage()
    }
    
    @IBAction private func backBattonWasPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = image else { return }
        let activityView = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(activityView, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func fetchImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: URL(string: imageUrl)) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(_):
                self.alertPresenter?.showAlert(model: AlertModel(title: "Что то пошло не так :(",
                                                                 message: "Не удалось загрузить полноразмерную фото",
                                                                 buttonText: "ОК"))
            }
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
