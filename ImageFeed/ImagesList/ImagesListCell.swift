
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
}
