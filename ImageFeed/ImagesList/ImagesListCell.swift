
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
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(isLike: Bool) {
        if isLike {
            favoritesButton.setImage(UIImage(named: "Favorites Active"), for: .normal)
        } else {
            favoritesButton.setImage(UIImage(named: "Favorites No Active"), for: .normal)
        }
            
    }
}
