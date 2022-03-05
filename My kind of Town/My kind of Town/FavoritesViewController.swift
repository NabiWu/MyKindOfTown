//
//  FavoritesViewController.swift
//  My kind of Town
//
//  Created by Bohan Wu on 2/11/22.
//

import UIKit

class FavoritesViewController: UIViewController {

    weak var delegate: PlacesFavoriteDelegate?
    var favPlaces : [String] = DataManager.sharedInstance.listFavorites()
    
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    

    @IBAction func extiMyFavList(_ sender: UIButton) {
        dismiss(animated: true)
    }

}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.favoritePlace(name: favPlaces[indexPath.row])
        dismiss(animated: true)
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "favCell")
        cell.textLabel?.text = favPlaces[indexPath.row]
        return cell
    }
}
