//
//  FriendsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit

// MARK: - UITableViewController
class FriendsTableViewController: UITableViewController {

    // MARK: - Hard code data (TEST)
    var users: [User] = [User(id: 645353,
                              name: "Александр",
                              surname: "Кузнецов",
                              photos: ["AlexandrKuznetsov", "AlexandrKuznetsov"],
                              avatar: "AlexandrKuznetsov"),
                         User(id: 945764,
                              name: "Andy",
                              surname: "Hopkins",
                              photos: ["AndyHopkins", "AndyHopkins", "AndyHopkins"],
                              avatar: "AndyHopkins"),
                         User(id: 784374,
                              name: "Antonio",
                              surname: "Levitskiy"),
                         User(id: 526374,
                              name: "Ева",
                              surname: "Денисова",
                              photos: ["EvaDenisova", "EvaDenisova", "EvaDenisova", "EvaDenisova", "EvaDenisova"]),
                         User(id: 193847,
                              name: "John",
                              surname: "Smith",
                              avatar: "JohnSmith"),
                         User(id: 738473,
                              name: "Лев",
                              surname: "Фёдоров",
                              photos: ["LevFedorov", "photoSecond", "photoThird", "photoFourth", "photoWoman", "Mom"],
                              avatar: "LevFedorov"),
                         User(id: 938263,
                              name: "Лилия",
                              surname: "Зимина",
                              photos: ["LiliaZimina", "photoWomanSecond"],
                              avatar: "LiliaZimina"),
                         User(id: 125638,
                              name: "Miron",
                              surname: "Abduraid",
                              photos: ["MironAbduraid"],
                              avatar: "MironAbduraid"),
                         User(id: 354639,
                              name: "Ольга",
                              surname: "Винокурова",
                              photos: ["OlgaVinokyrova", "photoWomanThird"],
                              avatar: "OlgaVinokyrova")]

} 

// MARK: - DataSource
extension FriendsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell",
                                                 for: indexPath) as? FriendsTableViewCell

        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let size = view.bounds.size.applying(scale)

        guard let avatarName = users[indexPath.row].avatar,
              let path = Bundle.main.path(forResource: avatarName, ofType: "jpg"),
              let userAvatar = cell?.friendImage?.resizedImage(at: path, for: size)
        else {
            return UITableViewCell()
        }

        cell?.friendImage?.image = userAvatar
        cell?.friendName?.text = "\(users[indexPath.row].name) \(users[indexPath.row].surname)"

        return cell ?? UITableViewCell()
    }

    // Prepare data to transfer at next viewCOntroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        if segue.identifier == "ShowFriendPhotos",
           let friendPhotoVC = segue.destination as? FriendPhotosCollectionViewController {
            friendPhotoVC.userPhotos = users[indexPath.row].photos ?? [String]()
        }
    }
}
