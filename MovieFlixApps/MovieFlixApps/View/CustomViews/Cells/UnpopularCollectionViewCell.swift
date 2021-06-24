//
//  UnpopularCollectionViewCell.swift
//  MovieFlixApps
//
//  Created by Tim on 24/06/2021.
//

import UIKit

class UnpopularCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageParentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var overViewLbl: UILabel!
    
    private var downloadTask: URLSessionDownloadTask?
    let identifier: String = String(describing: UnpopularCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupImageView()
    }
    
    var unpopular: MovieResultModel? {
        didSet {
            if let unpopular = unpopular {
                let baseMovieUrl = Api.posterPathBaseUrl
                let posterPath = unpopular.posterPath
                let appendedString = "\(baseMovieUrl)\(posterPath)"
                let fileUrl = URL(string: appendedString)
                self.downloadItemImageForSearchResult(imageURL: fileUrl)
                titleLbl.text = unpopular.title
                overViewLbl.text = unpopular.overview
            }
        }
    }
    
    func setupImageView() {
        imageView.layer.cornerRadius = 20
    }
    
    public func downloadItemImageForSearchResult(imageURL: URL?) {
        
        if let urlOfImage = imageURL {
            if let cachedImage = imageCache.object(forKey: urlOfImage.absoluteString as NSString){
                self.imageView!.image = cachedImage as? UIImage
            } else {
                let session = URLSession.shared
                self.downloadTask = session.downloadTask(
                    with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
                        if error == nil, let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
                            DispatchQueue.main.async() {
                                let imageToCache = image
                                if let strongSelf = self, let imageView = strongSelf.imageView {
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
        imageView?.image = UIImage(named: "ImagePlaceholder")
    }
    
    deinit {
        self.downloadTask?.cancel()
        imageView?.image = nil
    }
}
