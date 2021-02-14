//
//  ImagesTestProject
//  Created by Anatoly Gurbanov on 14.02.2021.
//

import UIKit

protocol ImageRepresentable {
    var image: UIImage { get }
}

struct ImageCellViewModel: ImageRepresentable {
    var image: UIImage
}
