
import UIKit
import Kingfisher


protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? {get}
    func updateTableView(date photos: [Photo])
}

class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        }
    }
   
    private(set) var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var alertPresenter: AlertPresenter?
    private let imagesListService = ImagesListService()
    
    var presenter: ImageListPresenterProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegat: self)
      
        if presenter == nil {
            presenter = ImageListPresenter(dataModelImageList: ImageListModel(), view: self)
        }
        presenter?.viewDidLoad()
    }
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            presenter?.fetchPhotos()
        }
    }
    
    func updateTableView(date photos: [Photo]) {
        let oldCount = self.photos.count
        self.photos = photos
        let newCount = self.photos.count
        UIBlockingProgressHUD.dismiss()
        updateTableViewAnimated(oldCount, newCount)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let date = photos[indexPath.row].createdAt == nil ? "" : dateFormatter.string(from: photos[indexPath.row].createdAt!)
        let namePhotoButton = photos[indexPath.row].isLiked ? "Favorites Active" : "Favorites No Active"
        let photoName = photos[indexPath.row].thumbImageURL
        let modelCell = ImagesListCellModel(photoName: photoName,
                                            date: date,
                                            favoritesName: namePhotoButton) { [weak self] in
            guard let self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.delegate = self
        cell.configureCell(with: modelCell)
    }

    private func updateTableViewAnimated(_ oldCount: Int, _ newCount: Int) {
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
        return UITableView.automaticDimension
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
    
    // TODO: Закопался, потерял много времени, и не смог придумать как вынести эту функцию в презентер и там еще обновить ячейку. Так как сделано изначально через NotificationCenter
    
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

