//
//  ImagesTestProject
//  Created by Anatoly Gurbanov on 13.02.2021.
//

import UIKit

class ImageController: UIViewController {

    private let refreshControl = UIRefreshControl()
    var networkService: NetworkServiceProtocol! {
        NetworkService.shared
    }
    var cellViewModel: ImageRepresentable?

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureRefreshControl()
    }

    // MARK: - Configuration

    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc
    private func refreshData(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "ImageViewCell", bundle: .main),
            forCellReuseIdentifier: "ImageViewCell"
        )
    }

    func presentAlert(with text: String) {

        let alert = UIAlertController(title: "",
                                      message: text,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}
