//
//  HomeViewController.swift
//  MovieFlixApps
//
//  Created by Tim on 24/06/2021.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    @IBOutlet weak var txtFieldParentView: UIView!
    @IBOutlet weak var txtField: UITextField!
    let movieDataViewModel = MovieDataViewModel(dataService: DataService.shared)
    var disposedBag = DisposeBag()
    var movieResultArray: [MovieResultModel?] = []
    var backupMovieResultArray: [MovieResultModel?] = []
    var selectedCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMovieDataResults()
        setupMovieListCollectionView()
        setupTxtFieldParentView()
    }

    func setupTxtFieldParentView() {
        txtFieldParentView.layer.cornerRadius = 20
        txtFieldParentView.backgroundColor = .systemGray3
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.backgroundColor = .systemBackground
        bar.setItems([flexibleSpace, done], animated: false)
        bar.tintColor = .label
        bar.sizeToFit()
        txtField.inputAccessoryView = bar
        txtField.tintColor = .label
        txtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    func setupMovieDataResults() {
        movieDataViewModel.movieResult.asObservable()
            .subscribe(onNext: { [unowned self]
                result in
                movieResultArray = result?.results.map{$0} ?? [MovieResultModel]()
                backupMovieResultArray = result?.results.map{$0} ?? [MovieResultModel]()
                movieListCollectionView.reloadData()
            })
            .disposed(by: disposedBag)
        movieDataViewModel.getMovieData()
    }
    func setupMovieListCollectionView() {
        movieListCollectionView.register(UINib(nibName: PopularCollectionViewCell().identifier, bundle: nil), forCellWithReuseIdentifier: PopularCollectionViewCell().identifier)
        movieListCollectionView.register(UINib(nibName: UnpopularCollectionViewCell().identifier, bundle: nil), forCellWithReuseIdentifier: UnpopularCollectionViewCell().identifier)
    }
    
    @objc func doneTapped() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let contentArray = backupMovieResultArray
        guard let text = textField.text?.lowercased() else { return  }
        var movieDetails: [MovieResultModel?] = []
        if !text.isEmpty {
            var i = 0
            while i < contentArray.count {
                let fullName = contentArray[i]?.title.lowercased()
                if fullName?.range(of:text) != nil {
                    movieDetails.append(contentArray[i])
                } else {
                    print("do Nothing")
                }
                i += 1
            }
            movieResultArray = movieDetails
            movieListCollectionView.reloadData()
        } else {
            movieResultArray = backupMovieResultArray
            movieListCollectionView.reloadData()
        }
    }
}
