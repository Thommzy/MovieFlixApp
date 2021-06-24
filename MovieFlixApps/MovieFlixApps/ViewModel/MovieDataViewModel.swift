//
//  MovieDataViewModel.swift
//  MovieFlixApps
//
//  Created by Tim on 24/06/2021.
//
import RxSwift
import RxCocoa

class MovieDataViewModel {
    
    let movieResult: BehaviorRelay<MovieModel?> = BehaviorRelay(value: nil)
    let error: BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    private var dataService: DataService?
    
    // MARK: - Constructor
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    //MARK: - Network Call
    func getMovieData() {
        self.dataService?.requestMovieData(completion: { (user, error) in
            if let error = error {
                self.error.accept(error)
                return
            }
            self.error.accept(nil)
            self.movieResult.accept(user)
        })
    }
}
