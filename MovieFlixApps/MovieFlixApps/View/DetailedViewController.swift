//
//  DetailedViewController.swift
//  MovieFlixApps
//
//  Created by Tim on 24/06/2021.
//

import UIKit

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var movieData: MovieResultModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
    }
    
    func setupImageView() {
        let baseMovieUrl = Api.posterPathBaseUrl
        let posterPath = movieData?.posterPath
        let appendedString = "\(baseMovieUrl)\(posterPath ?? String())"
        let fileUrl = URL(string: appendedString)!
        imageView.downloaded(from: fileUrl)
        imageView.layer.cornerRadius = 20
    }
}
