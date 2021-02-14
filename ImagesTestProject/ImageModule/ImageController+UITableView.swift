//
//  ImagesTestProject
//  Created by Anatoly Gurbanov on 14.02.2021.
//

import UIKit

extension ImageController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }

    // MARK: - UITablaViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as? ImageViewCell,
           let imageURL = NetworkConfiguration.baseURLString(index: indexPath.row).urlString {
            downloadImage(withURL: imageURL, forCell: cell)
//            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Download Image
    
    private func downloadImage(withURL url: URL, forCell cell: UITableViewCell) {
        networkService.makeRequest(withURL: url) { [weak self] image, error in
            
            guard let self = self else {
                return
            }

            DispatchQueue.main.async {
                if let image = image, let cell = cell as? ImageViewCell {

                    self.cellViewModel = ImageCellViewModel(image: image)
                    if let viewModel = self.cellViewModel {
                        cell.configure(withViewModel: viewModel)
                    }
                } else if let error = error {
                    self.presentAlert(with: error)
                }
            }
        }
    }
}
