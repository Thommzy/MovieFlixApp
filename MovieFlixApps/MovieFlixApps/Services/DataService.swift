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
        let url = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
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
