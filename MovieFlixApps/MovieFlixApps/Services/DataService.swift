//
//  DataService.swift
//  MovieFlixApps
//
//  Created by Tim on 24/06/2021.
//

import Foundation
import Alamofire

struct DataService {
    
    // MARK: - Singleton
    static let shared = DataService()
    
    func requestMovieData(completion: @escaping (MovieModel?, Error?) -> ()) {
        let url = "\(Api.BASEURL)?api_key=\(Api.API_KEY)"
        AF.request(url).responseDecodable(of: MovieModel.self) { response in
            if let error = response.error {
                completion(nil, error)
                return
            }
            if let user = response.value {
                completion(user, nil)
                return
            }
        }
    }
}
