
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet private weak var photo: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var favoritesButton: UIButton!
    
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        photo.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(isLike: Bool) {
        let image = UIImage(named: isLike ? "Favorites Active" : "Favorites No Active")
        favoritesButton.setImage(image, for: .normal)
    }
    
    func configureCell(with model: ImagesListCellModel) {
        photo.kf.indicatorType = .activity
        dateLabel.text = model.date
        favoritesButton.setImage(UIImage(named: model.favoritesName), for: .normal)
        let url = URL(string: model.photoName)
        photo.kf.setImage(with: url, placeholder: UIImage(named: "stub"), completionHandler: { _ in
            model.completion()
        })
    }
}
