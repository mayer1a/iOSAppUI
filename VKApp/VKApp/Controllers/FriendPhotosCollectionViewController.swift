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

        setupData()
    }


    // MARK: - viewWillTransition

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { [weak self] _ in

            self?.setupImageCellSize()
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
            let userPhoto = cell?.friendPhoto?.resizedImage(at: path)
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


    // MARK: - setupData

    private func setupData() {

        do {
            let photos = try RealmPhoto.restoreData(userId: userId)
            let userDefaults = UserDefaults.standard
            let currentTime = Int(Date().timeIntervalSince1970)

            if currentTime - userDefaults.integer(forKey: "photosLastLoad") > 1800 || photos.isEmpty {
                loadPhotos()
                
                userDefaults.set(currentTime, forKey: "photosLastLoad")
            } else {
                self.photos = photos

                self.collectionView.reloadData()
            }
        } catch {
            print(error)
        }
        
    }


    // MARK: - loadData()

    private func loadPhotos() {

        SessionManager.shared.loadUserPhotos(id: userId) { photos in
            DispatchQueue.main.async {  [weak self] in
                self?.photos = photos
                self?.collectionView.reloadData()
            }
        }
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

}


// MARK: - UICollectionViewDelegateFlowLayout

extension FriendPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {


    // MARK: - sizeForItemAt

    // Change cell size by ui screen width - three cells per row
    private func setupImageCellSize() {

        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let photosPerRow: CGFloat = UIDevice.current.orientation.isPortrait ? 3.0 : 5.0
        let minimumSpacing = layout.minimumInteritemSpacing
        let width = self.collectionView.safeAreaLayoutGuide.layoutFrame.width
        let itemSize = ((width - minimumSpacing * (photosPerRow - 1.0)) / photosPerRow)

        layout.itemSize = CGSize(width: itemSize, height: itemSize)
    }

}
