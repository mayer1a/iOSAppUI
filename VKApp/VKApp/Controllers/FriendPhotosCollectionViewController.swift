//
//  FriendPhotosCollectionViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit

class FriendPhotosCollectionViewController: UICollectionViewController {

    var userPhotos: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = userPhotos[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoViewCell",
                                                      for: indexPath) as? FriendPhotoCollectionViewCell

        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let size = view.bounds.size.applying(scale)

        guard let path = Bundle.main.path(forResource: photo, ofType: "jpg"),
              let userPhoto = cell?.friendPhoto?.resizedImage(at: path, for: size) else {
            return UICollectionViewCell()
        }

        cell?.friendPhoto?.image = userPhoto

        return cell ?? UICollectionViewCell()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension FriendPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {

    // Change cell size by ui screen width
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let itemSize = (screenWidth / 3) - 15

        return CGSize(width: itemSize, height: itemSize)
    }

}
