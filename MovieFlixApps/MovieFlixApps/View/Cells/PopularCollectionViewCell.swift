//
//  PopularCollectionViewCell.swift
//  MovieFlixApps
//
//  Created by Tim on 24/06/2021.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var parentView: UIView!
    
    let identifier: String = String(describing: PopularCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupParentView()
    }
    
    func setupParentView() {
        parentView.layer.cornerRadius = 20
    }
    
}
