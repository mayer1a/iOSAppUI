//
//  FriendPhotosCollectionViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit


// MARK: - FriendPhotosCollectionViewControllerDelegate

protocol FriendPhotosCollectionViewControllerDelegate {
    func photoDidLiked(userIndexPath: IndexPath, photoIndexPath: IndexPath, isLiked: Bool)
}


class FriendPhotosCollectionViewController: UICollectionViewController {

    var userPhotos: [Photo] = []
    var tableViewIndexPath = IndexPath()
    var delegate: FriendPhotosCollectionViewControllerDelegate?


    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
    }


    // MARK: - numberOfItemsInSection

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPhotos.count
    }


    // MARK: - cellForItemAt

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = userPhotos[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoViewCell",
                                                      for: indexPath) as? FriendPhotoCollectionViewCell

        guard let path = Bundle.main.path(forResource: photo.name, ofType: "jpg"),
              let userPhoto = cell?.friendPhoto?.resizedImage(at: path, for: imageSize()) else {
            return UICollectionViewCell()
        }

        cell?.friendPhoto?.image = userPhoto
        cell?.likeControl?.isSelected = photo.isLiked

        cell?.photoDidLiked = { [weak self] isLiked in

            guard let self = self else { return }

            self.delegate?.photoDidLiked(userIndexPath: self.tableViewIndexPath,
                                         photoIndexPath: indexPath,
                                         isLiked: isLiked)

            self.userPhotos[indexPath.item].isLiked = isLiked

        }
        
        return cell ?? UICollectionViewCell()
    }


    // MARK: - imageSize

    func imageSize() -> CGSize {
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        return view.bounds.size.applying(scale)
    }

}


// MARK: - UICollectionViewDelegateFlowLayout

extension FriendPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - sizeForItemAt

    // Change cell size by ui screen width - three cells per row
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let itemSize = (screenWidth / 3) - 15

        return CGSize(width: itemSize, height: itemSize)
    }

}
