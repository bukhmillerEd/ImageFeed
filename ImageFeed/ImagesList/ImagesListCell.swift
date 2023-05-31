
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    
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
}
