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
    private var realmNotification: NotificationToken?
    private let operationQueue = OperationQueue()
    
    var photos : [Photo]?
    var userId = Int()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
        
        makeObserver()
        dataValidityCheck()
    }
    
    // MARK: - viewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate { _ in
            self.setupImageCellSize()
        }
    }
    
    // MARK: - numberOfItemsInSection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
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
            let imageURL = URL(string: photo.smallSizeUrl)
        else { return UICollectionViewCell() }
        
        DispatchQueue.global().async { [weak cell] in
            let image = UIImage.fetchImage(at: imageURL)
            
            DispatchQueue.main.async {
                cell?.friendPhoto?.image = image
            }
        }
        
        if let isLiked = photo.isLiked, let likeCount = photo.likesCounter {
            cell?.likeControl?.isSelected = isLiked == 1 ? true : false
            cell?.likeControl?.likeLabel?.text = String(likeCount)
            cell?.likeControl?.setupLikesCounter(equal: likeCount)
        }
        
        cell?.photoDidLiked = { [weak self] isLiked in
            self?.photos?[indexPath.item].isLiked = isLiked ? 1 : 0
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
    
    // MARK: - makeObserver
    private func makeObserver() {
        self.realmNotification = RealmObserver
            .shared
            .makeObserver(ownerId: self.userId) { (photos: [RealmPhoto], changes) in
                DispatchQueue.main.async { [weak self] in
                    self?.setupData(from: photos, with: changes)
                }
            }
    }
    
    // MARK: - dataValidityCheck
    private func dataValidityCheck() {
        do {
            let photos = try RealmPhoto.restoreData(ownerId: userId)
            
            if photos.isEmpty {
                let request = SessionManager.shared.getPhotosRequest(id: userId)
                let fetchDataOperations = FetchDataOperation(request: request)
                let asyncParseOperation = AsyncParseDataOperation<Photo>()
                let saveRealmOperation = SaveRealmOperation<Photo>()
                
                asyncParseOperation.addDependency(fetchDataOperations)
                saveRealmOperation.addDependency(asyncParseOperation)
                
                operationQueue.qualityOfService = .userInteractive
                operationQueue.addOperation(fetchDataOperations)
                operationQueue.addOperation(asyncParseOperation)
                operationQueue.addOperation(saveRealmOperation)
            } else {
                self.setupData(from: photos)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - setupData
    private func setupData(from photos: [RealmPhoto], with changes: ([Int], [Int], [Int])? = nil) {
        let userPhotos = RealmPhoto.realmToPhoto(from: photos, by: userId)
        self.photos = userPhotos
        
        if let changes = changes {
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
        } else {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - prepareForPushViewControllerAtSender
    private func prepare(for pushViewController: UIViewController, at sender: IndexPath?) {
        guard
            let photos = photos,
            let indexPath = sender,
            let fullScreenPhotoVC = pushViewController as? FullScreenUserPhoto
        else { return }
        
        fullScreenPhotoVC.photos = photos
        fullScreenPhotoVC.showPhotoIndex = indexPath.item
    }
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
