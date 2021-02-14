//
//  ImagesTestProject
//  Created by Anatoly Gurbanov on 14.02.2021.
//

import UIKit

class ImageViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var cellImageView: UIImageView!

    // MARK: - Configuration

    func configure(withViewModel viewModel: ImageRepresentable) {
        DispatchQueue.main.async {
            self.cellImageView.image = viewModel.image
        }
    }
}
