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
    var globalBackdropArray: [MovieResultModel?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMovieDataResults()
        setupMovieListCollectionView()
    }
    
    func setupMovieDataResults() {
        movieDataViewModel.movieResult.asObservable()
            .subscribe(onNext: { [unowned self]
                result in
                //print(result?.results.map{$0?.posterPath}, "<<<<<<>>>>")
                globalBackdropArray = result?.results.map{$0} ?? [MovieResultModel]()
                movieListCollectionView.reloadData()
            })
            .disposed(by: disposedBag)
        movieDataViewModel.getMovieData()
    }
    
    func setupMovieListCollectionView() {
        movieListCollectionView.register(UINib(nibName: PopularCollectionViewCell().identifier, bundle: nil), forCellWithReuseIdentifier: PopularCollectionViewCell().identifier)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalBackdropArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell().identifier, for: indexPath) as? PopularCollectionViewCell
        cell?.popular = globalBackdropArray[indexPath.row]
        cell?.layoutIfNeeded()
        return cell!
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 30, height: 200)
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
