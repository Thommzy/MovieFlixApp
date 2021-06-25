//
//  HomeViewController+Extension.swift
//  MovieFlixApps
//
//  Created by Tim on 25/06/2021.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieResultArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if movieResultArray[indexPath.row]?.voteAverage ?? Double() > 7.0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell().identifier, for: indexPath) as? PopularCollectionViewCell
            cell?.popular = movieResultArray[indexPath.row]
            cell?.delegate = self
            cell?.layoutIfNeeded()
            return cell!
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnpopularCollectionViewCell().identifier, for: indexPath) as? UnpopularCollectionViewCell
        cell?.delegate = self
        cell?.unpopular = movieResultArray[indexPath.row]
        cell?.layoutIfNeeded()
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.row
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

extension HomeViewController : PopularCollectionViewCellDelegate {
    func popularDeleteBtnTapped(cell: PopularCollectionViewCell) {
        let indexPath = self.movieListCollectionView.indexPath(for: cell)
        self.movieResultArray.remove(at: indexPath?.row ?? Int())
        let indexPaths = IndexPath(item: indexPath?.row ?? Int(), section: 0)
        movieListCollectionView.deleteItems(at: [indexPaths])
    }
}

extension HomeViewController : UnpopularCollectionViewCellDelegate {
    func unpopularDeleteBtnTapped(cell: UnpopularCollectionViewCell) {
        let indexPath = self.movieListCollectionView.indexPath(for: cell)
        self.movieResultArray.remove(at: indexPath?.row ?? Int())
        let indexPaths = IndexPath(item: indexPath?.row ?? Int(), section: 0)
        movieListCollectionView.deleteItems(at: [indexPaths])
    }
}
