//
//  ImagesTestProject
//  Created by Anatoly Gurbanov on 13.02.2021.
//

import UIKit

public typealias NetworkResponseResult = (_ image: UIImage?, _ error: String?) -> Void

protocol NetworkServiceProtocol {
    func makeRequest(withURL url: URL, completion: @escaping NetworkResponseResult)
    func cancel()
}

class NetworkService: NetworkServiceProtocol {
    // MARK: - Properties

    static let shared: NetworkService = NetworkService()
    private let imageCache = NSCache<AnyObject, UIImage>()
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    // MARK: - Initializer
    
    private init () {}
    
    // MARK: - Functions

    func makeRequest(withURL url: URL, completion: @escaping NetworkResponseResult) {

        if let cachedImage = imageCache.object(forKey: url.absoluteString as AnyObject) {
            completion(cachedImage, nil)
        }
        
        DispatchQueue.global().async {
            self.task = self.session.dataTask(with: url) { data, response, error in

                if let error = error {
                    completion(nil, error.localizedDescription)
                }

                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)

                    switch result {
                    case .success:
                        guard let data = data, let image = UIImage(data: data) else {
                            return
                        }
                        self.imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
                        completion(image, nil)
                    case .failure(let responseError):
                        completion(nil, responseError)
                    }
                }

            }
            self.task?.resume()
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }

    private func handleNetworkResponse(_ response: HTTPURLResponse) -> ResponseResult<String>{
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599:
            return .failure(NetworkResponse.badRequest.rawValue)
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
