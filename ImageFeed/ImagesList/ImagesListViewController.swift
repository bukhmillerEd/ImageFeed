
import UIKit
import Kingfisher


protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

class ImagesListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
   
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService()
    private var imageListServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenter?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        addObserver()
        alertPresenter = AlertPresenter(delegat: self)
        if let token = OAuth2TokenStorage.shared.token {
            imagesListService.fetchPhotosNextPage(token)
        }
    }
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            if let token = OAuth2TokenStorage.shared.token {
                imagesListService.fetchPhotosNextPage(token)
            }
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        cell.dateLabel.text = photos[indexPath.row].createdAt == nil ? "" : dateFormatter.string(from: photos[indexPath.row].createdAt!)
        let namePhotoButton = photos[indexPath.row].isLiked ? "Favorites Active" : "Favorites No Active"
        cell.favoritesButton.setImage(UIImage(named: namePhotoButton), for: .normal)
        let url = URL(string: photos[indexPath.row].thumbImageURL)
        cell.photo.kf.indicatorType = .activity
        cell.photo.kf.setImage(with: url, placeholder: UIImage(named: "stub")) { [weak self] _ in
            guard let self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func addObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated();
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }

}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let vc = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else { return }
            vc.imageUrl = photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    UIBlockingProgressHUD.dismiss()
                    self.photos[indexPath.row].isLiked.toggle()
                    cell.setIsLiked(isLike: photo.isLiked)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure(_):
                    UIBlockingProgressHUD.dismiss()
                    self.alertPresenter?.showAlert(
                        model: AlertModel(title: "Что-то пошло не так(",
                                          message: "Не удалось изменить лайк",
                                          buttonText: "Ok"))
                }
            }
        }
    }
    
}

