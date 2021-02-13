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

    private var task: URLSessionTask?
    private let session = URLSession.shared

    func makeRequest(withURL url: URL, completion: @escaping NetworkResponseResult) {

        task = session.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(nil, error.localizedDescription)
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)

                switch result {
                case .success:
                    guard let data = data else {
                        return
                    }
                    let image = UIImage(data: data)
                    completion(image, nil)
                case .failure(let responseError):
                    completion(nil, responseError)
                }
            }

        }
        task?.resume()
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
