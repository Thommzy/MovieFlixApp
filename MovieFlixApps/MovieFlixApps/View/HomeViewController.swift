//
//  HomeViewController.swift
//  MovieFlixApps
//
//  Created by Tim on 24/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    let movieDataViewModel = MovieDataViewModel(dataService: DataService.shared)
    var disposedBag = DisposeBag()
    var movieResultArray: [MovieResultModel?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMovieDataResults()
        setupMovieListCollectionView()
    }
    
    func setupMovieDataResults() {
        movieDataViewModel.movieResult.asObservable()
            .subscribe(onNext: { [unowned self]
                result in
                movieResultArray = result?.results.map{$0} ?? [MovieResultModel]()
                movieListCollectionView.reloadData()
            })
            .disposed(by: disposedBag)
        movieDataViewModel.getMovieData()
    }
    
    func setupMovieListCollectionView() {
        movieListCollectionView.register(UINib(nibName: PopularCollectionViewCell().identifier, bundle: nil), forCellWithReuseIdentifier: PopularCollectionViewCell().identifier)
        movieListCollectionView.register(UINib(nibName: UnpopularCollectionViewCell().identifier, bundle: nil), forCellWithReuseIdentifier: UnpopularCollectionViewCell().identifier)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieResultArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if movieResultArray[indexPath.row]?.voteAverage ?? Double() > 7.0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell().identifier, for: indexPath) as? PopularCollectionViewCell
            cell?.popular = movieResultArray[indexPath.row]
            cell?.layoutIfNeeded()
            return cell!
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnpopularCollectionViewCell().identifier, for: indexPath) as? UnpopularCollectionViewCell
        cell?.unpopular = movieResultArray[indexPath.row]
        cell?.layoutIfNeeded()
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedVc = storyboard.instantiateViewController(withIdentifier: "DetailedViewController") as! DetailedViewController
        detailedVc.movieData = movieResultArray[indexPath.row]
        self.navigationController?.pushViewController(detailedVc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 30, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
