//
//  FriendPhotosCollectionViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit
import RealmSwift

// MARK: - UICollectionViewController
final class FriendPhotosCollectionViewController: UICollectionViewController {
    private var imageCachingService: ImageCachingService?
    private let friendsPhotoAdapter = FriendsPhotoAdapter()
    
    var photos: [Photo]?
    var userId = Int()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCachingService = ImageCachingService(from: self.collectionView)
        dataValidityCheck()
    }
    
    // MARK: - viewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { [weak self] _ in
            self?.updateCellSize()
        }
    }

    // MARK: - numberOfItemsInSection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = photos?.count ?? 0

        self.updateCellSize()

        return count
    }

    // MARK: - cellForItemAt
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoViewCell",
                                                      for: indexPath) as? FriendPhotoCollectionViewCell
        
        cell?.friendPhoto?.image = UIImage(named: "NonAvatar")
        
        guard
            let photo = photos?[indexPath.item],
            let path = photo.smallSizeUrl
        else { return UICollectionViewCell() }

        imageCachingService?.getImage(at: indexPath, by: path) { image in
            cell?.friendPhoto?.image = image
        }
        
        if let isLiked = photo.isLiked, let likeCount = photo.likesCounter {
            cell?.likeControl?.isSelected = isLiked
            cell?.likeControl?.likeLabel?.text = String(likeCount)
            cell?.likeControl?.setupLikesCounter(equal: likeCount)
        }
        
        cell?.photoDidLiked = { [weak self] isLiked in
            self?.photos?[indexPath.item].isLiked = isLiked
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
    
    // MARK: - dataValidityCheck
    private func dataValidityCheck() {
        friendsPhotoAdapter.getPhotos(by: userId) { [weak self] (photos, changes) in
            self?.setupData(from: photos, with: changes)
        }
    }
    
    // MARK: - setupData
    private func setupData(from photos: [Photo], with changes: ([Int], [Int], [Int])?) {
        self.photos = photos

        guard
            let changes = changes
        else {
            self.collectionView.reloadData()
            return
        }
        
        DispatchQueue.global().async {
            let deletionIndexes = changes.0.reduce(into: [IndexPath]()) {
                $0.append(IndexPath(item: $1, section: 0))
            }

            let insertionIndexes = changes.1.reduce(into: [IndexPath]()) {
                $0.append(IndexPath(item: $1, section: 0))
            }

            let reloadIndexes = changes.2.reduce(into: [IndexPath]()) {
                $0.append(IndexPath(item: $1, section: 0))
            }

            DispatchQueue.main.async { [weak self] in
                self?.collectionView.performBatchUpdates {
                    self?.collectionView.deleteItems(at: deletionIndexes)
                    self?.collectionView.insertItems(at: insertionIndexes)
                    self?.collectionView.reloadItems(at: reloadIndexes)
                }
            }
        }
    }
    
    // MARK: - prepareForPushViewControllerAtSender
    private func prepare(for pushViewController: UIViewController, at sender: IndexPath?) {
        guard
            let photos = photos,
            let indexPath = sender,
            let fullScreenPhotoVC = pushViewController as? FullScreenUserPhoto,
            let imagePath = photos[indexPath.item].smallSizeUrl
        else { return }

        fullScreenPhotoVC.photos = photos
        fullScreenPhotoVC.currentPhotoIndex = indexPath.item

        imageCachingService?.getImage(at: indexPath, by: imagePath) { image in
            fullScreenPhotoVC.startImage = image
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FriendPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - updateCellSize
    func updateCellSize() {
        guard
            let layout = collectionViewLayout as? UICollectionViewFlowLayout,
            let isPortraitOrientation = self.view.window?.windowScene?.interfaceOrientation.isPortrait
        else { return }

        tabBarController?.tabBar.isHidden = isPortraitOrientation ? false : true

        let minimumSpacing = layout.minimumInteritemSpacing
        let width = self.collectionView.safeAreaLayoutGuide.layoutFrame.width
        let photosPerRow: CGFloat = isPortraitOrientation ? 3.0 : 5.0
        let side = (width - minimumSpacing * (photosPerRow - 1.0)) / photosPerRow

        (self.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: side, height: side)
    }
}

// MARK: - ViewPresentable
extension FriendPhotosCollectionViewController: ViewPresentable {

    // MARK: - photoCellViewRectOfItemIndex
    func photoCellViewRect(of itemIndex: Int) -> CGRect {
        let indexPath = IndexPath(item: itemIndex, section: 0)
        var cellRect = collectionView(collectionView, cellForItemAt: indexPath).frame
        let offset = collectionView.contentOffset
        let newOrigin = CGPoint(x: cellRect.origin.x, y: cellRect.origin.y - offset.y)

        cellRect.origin = newOrigin

        return cellRect
    }

    // MARK: - photoCellViewRect
    func photoCellViewRect() -> CGRect {
        guard let selectedCellIndexPath = collectionView.indexPathsForSelectedItems?.first
        else {
            print("We have some problem....")
            return CGRect.zero }

        var cellRect = collectionView(collectionView, cellForItemAt: selectedCellIndexPath).frame
        let offset = collectionView.contentOffset
        let newOrigin = CGPoint(x: cellRect.origin.x, y: cellRect.origin.y - offset.y)

        cellRect.origin = newOrigin

        return cellRect
    }
}
