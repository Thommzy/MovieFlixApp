//
//  PopularCollectionViewCell.swift
//  MovieFlixApps
//
//  Created by Tim on 24/06/2021.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>.sharedInstance


class PopularCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var popularImageView: UIImageView!
    
    private var downloadTask: URLSessionDownloadTask?
    
    let identifier: String = String(describing: PopularCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupParentView()
    }
    
    var popular: MovieResultModel? {
        didSet {
            if let popular = popular {
                let baseMovieUrl = "https://image.tmdb.org/t/p/original"
                let backdropPath = popular.backdropPath
                let appendedString = "\(baseMovieUrl)\(backdropPath)"
                let fileUrl = URL(string: appendedString)
                self.downloadItemImageForSearchResult(imageURL: fileUrl)
            }
        }
    }
    
    func setupParentView() {
        parentView.layer.cornerRadius = 20
        parentView.layer.masksToBounds = true
    }
    
    public func downloadItemImageForSearchResult(imageURL: URL?) {
        
        if let urlOfImage = imageURL {
            if let cachedImage = imageCache.object(forKey: urlOfImage.absoluteString as NSString){
                self.popularImageView!.image = cachedImage as? UIImage
            } else {
                let session = URLSession.shared
                self.downloadTask = session.downloadTask(
                    with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
                        if error == nil, let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
                            DispatchQueue.main.async() {
                                let imageToCache = image
                                if let strongSelf = self, let imageView = strongSelf.popularImageView {
                                    imageView.image = imageToCache
                                    imageCache.setObject(imageToCache, forKey: urlOfImage.absoluteString as NSString , cost: 1)
                                }
                            }
                        } else {
                            print("ERROR \(error?.localizedDescription ?? String())")
                        }
                    })
                self.downloadTask!.resume()
            }
        }
    }
    
    override public func prepareForReuse() {
        self.downloadTask?.cancel()
        popularImageView?.image = UIImage(named: "ImagePlaceholder")
    }
    
    deinit {
        self.downloadTask?.cancel()
        popularImageView?.image = nil
    }
}
