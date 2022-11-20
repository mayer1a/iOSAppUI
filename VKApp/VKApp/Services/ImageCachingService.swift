//
//  ImageCachingService.swift
//  VKApp
//
//  Created by Artem Mayer on 14.10.22.
//

import UIKit
import Alamofire

// MARK: - DataReloadable
fileprivate protocol DataReloadable {
    func reloadRow(at indexPath: IndexPath)
}

// MARK: - ImageCachingService
final class ImageCachingService {
    private enum CacheLifeTime: TimeInterval {
        case hour = 3_600
        case day = 86_400
        case week = 604_800
        case month = 2_592_000
    }

    private static let pathName: String = {
        let pathName = "ImagesCache"
        let url: URL
        let fileExists: Bool

        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return pathName }

        if #available(iOS 16.0, *) {
            url = cachesDirectory.appending(path: pathName, directoryHint: .isDirectory)
            fileExists = FileManager.default.fileExists(atPath: url.path())
        } else {
            url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
            fileExists = FileManager.default.fileExists(atPath: url.path)
        }

        if !fileExists {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }

        return pathName
    }()

    private let container: DataReloadable
    private var fastImagesCache = [String : UIImage]()

    init(from container: UITableView) {
        self.container = Table(from: container)
    }

    init(from container: UICollectionView) {
        self.container = Collection(from: container)
    }

    // MARK: - getFilePath
    private func getFilePath(by url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }

        let hashName = url.split(separator: "/").last ?? "default"
        let filePath: String


        if #available(iOS 16.0, *) {
            filePath = cachesDirectory.appending(path: "\(ImageCachingService.pathName)/\(hashName)").path()
        } else {
            filePath = cachesDirectory.appendingPathComponent("\(ImageCachingService.pathName)/\(hashName)").path
        }

        return filePath
    }

    // MARK: - saveImageToCache
    private func saveImageToCache(by url: String, image: UIImage) {
        guard
            let fileName = getFilePath(by: url),
            let data = image.pngData()
        else { return }

        FileManager.default.createFile(atPath: fileName, contents: data)
    }

    // MARK: - getImageFromCache
    private func getImageFromCache(by url: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard
                let fileName = self?.getFilePath(by: url),
                let info = try? FileManager.default.attributesOfItem(atPath: fileName),
                let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else {
                completion(nil)
                return
            }

            let lifeTime = Date().timeIntervalSince(modificationDate)

            guard lifeTime <= CacheLifeTime.day.rawValue else { return }

            DispatchQueue.main.async { [weak self] in
                guard let image = UIImage(contentsOfFile: fileName) else {
                    completion(nil)
                    return
                }

                self?.fastImagesCache[url] = image
                completion(image)
            }
        }

    }

    // MARK: - fetchImage
    private func fetchImage(at indexPath: IndexPath, by url: String) {
        AF.request(url).responseData(queue: DispatchQueue.global()) { [weak self] response in
            guard
                let data = response.data,
                let image = UIImage(data: data)
            else { return }

            self?.saveImageToCache(by: url, image: image)

            DispatchQueue.main.async {
                self?.fastImagesCache[url] = image
                self?.container.reloadRow(at: indexPath)
            }
        }
    }

    // MARK: - getImage
    func getImage(at indexPath: IndexPath, by url: String, completion: @escaping (UIImage?) -> Void) {
        if let photo = fastImagesCache[url] {
            completion(photo)
        } else {
            getImageFromCache(by: url) { [weak self] photo in
                guard let photo = photo else  {
                    self?.fetchImage(at: indexPath, by: url)
                    return
                }

                completion(photo)
            }
        }
    }
}

// MARK: - DataReloadable
private final class Table: DataReloadable {
    let tableView: UITableView

    init(from tableView: UITableView) {
        self.tableView = tableView
    }

    // MARK: - reloadRow
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - DataReloadable
private final class Collection: DataReloadable {
    let collectionView: UICollectionView
    
    init(from collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    // MARK: - reloadRow
    func reloadRow(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}
