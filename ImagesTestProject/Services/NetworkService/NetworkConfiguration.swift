//
//  ImagesTestProject
//  Created by Anatoly Gurbanov on 13.02.2021.
//

import Foundation

enum NetworkConfiguration {
    case baseURLString(index: Int)
    
    var urlString: URL? {
        switch self {
        case .baseURLString(let index):
            return URL(string: "http://placehold.it/375x150?text=\(index)")
        }
    }
}
