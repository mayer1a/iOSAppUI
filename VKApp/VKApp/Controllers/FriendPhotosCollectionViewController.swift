//
//  FriendPhotosCollectionViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit


final class FriendPhotosCollectionViewController: UICollectionViewController {

    var photos = [Photo]()
    var userId = Int()


    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero

        SessionManager.shared.loadUserPhotos(id: userId) { [weak self] photos in
            self?.photos = photos
            self?.collectionView.reloadData()
        }
    }


    // MARK: - numberOfItemsInSection

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }


    // MARK: - cellForItemAt

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = photos[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoViewCell",
                                                      for: indexPath) as? FriendPhotoCollectionViewCell

//        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellImageDidTapped(_:)))
//        cell?.friendPhoto?.addGestureRecognizer(gesture)

        guard
            let path = URL(string: photo.smallSizeUrl),
            let userPhoto = cell?.friendPhoto?.resizedImage(at: path, for: imageSize())
        else {
            return UICollectionViewCell()
        }

        cell?.friendPhoto?.image = userPhoto
        cell?.likeControl?.isSelected = photo.isLiked == 1 ? true : false
        cell?.likeControl?.likeLabel?.text = String(photo.likesCounter)
        cell?.likeControl?.setupLikesCounter(equal: photo.likesCounter)

        // TODO: метод "отправки лайка" на бек

        cell?.photoDidLiked = { [weak self] isLiked in

            self?.photos[indexPath.item].isLiked = isLiked ? 1 : 0
        }
        
        return cell ?? UICollectionViewCell()
    }


    // MARK: - didSelectItemAt

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let fullScreenUserPhoto = storyboard.instantiateViewController(withIdentifier: "FullScreenUserPhoto")

        prepare(for: fullScreenUserPhoto, at: indexPath)
        
        navigationController?.pushViewController(fullScreenUserPhoto, animated: true)
    }


    // MARK: - prepareForPushViewControllerAtSender

    private func prepare(for pushViewController: UIViewController, at sender: IndexPath?) {
        guard
            let indexPath = sender,
            let fullScreenPhotoVC = pushViewController as? FullScreenUserPhoto
        else {
            return
        }
        
        fullScreenPhotoVC.photos = photos
        fullScreenPhotoVC.showPhotoIndex = indexPath.item
    }


    // MARK: - cellDidTapped

//    @objc private func cellImageDidTapped(_ sender: Any) {
//        //        guard
//        //            let selectedImage = ((sender as? UITapGestureRecognizer)?.view as? PreviewScaledImageView)?.image
//        //        else {
//        //            return
//        //        }
//
//    }


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
