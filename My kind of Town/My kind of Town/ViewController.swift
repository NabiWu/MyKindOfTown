//
//  ViewController.swift
//  My kind of Town
//
//  Created by Bohan Wu on 2/10/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet var savedButton: UIButton!
    @IBOutlet var checkFavPlaces: UIButton!
    
    
    var selectedPlace : Place = Place()
    
    let locationManager = CLLocationManager()
    
    let customButtonTitle = NSMutableAttributedString(string: "FAVORITE PLACES", attributes: [
        NSAttributedString.Key.font: UIFont(name: "GillSans-Italic", size: 30) as Any,
        NSAttributedString.Key.backgroundColor: UIColor.yellow,
        NSAttributedString.Key.foregroundColor: UIColor.blue
    ])
    
//    let customButtonTitle2 = NSMutableAttributedString(string: "FAVORITE PLACES", attributes: [
//        NSAttributedString.Key.font: UIFont(name: "GillSans-Italic", size: 30) as Any,
//        NSAttributedString.Key.backgroundColor: UIColor.red,
//        NSAttributedString.Key.foregroundColor: UIColor.blue
//    ])
    
    let plist = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Data", ofType: "plist") ?? "No places")
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
    
        infoView.layer.cornerRadius = 10
//        infoView.isHidden = true
        place.adjustsFontSizeToFitWidth = true
        place.textColor = .white
        detail.textColor = .white
        checkFavPlaces.setAttributedTitle(customButtonTitle, for: .normal)
        
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.delegate = self
        mapView.setRegion(DataManager.sharedInstance.loadRegion(), animated: true)
        mapView.register(PlaceMarkerView.self, forAnnotationViewWithReuseIdentifier: "Place")
        
        savedButton.setImage(UIImage(systemName:"star"), for: .normal)
        savedButton.setImage(UIImage(systemName:"star.fill"), for: .selected)
        
        
        
        let places = DataManager.places
        for place in places {
            mapView.addAnnotation(place)
            if place.name == "Nema Chicago" {
                mapView.selectAnnotation(place, animated: true)
            }
        }
        
        print((plist?["places"]as! [[String: Any]])[0] as Any)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let miles: Double = 40 * 1600
        let centerPoint = CLLocationCoordinate2DMake(42.2,-87.6)
        let viewRegion = MKCoordinateRegion(center: centerPoint, latitudinalMeters: miles, longitudinalMeters: miles)
        mapView.setRegion(viewRegion, animated: true)
    }
    
    func updateInfoView(myPlace : Place) {
        let favPlaces = DataManager.sharedInstance.listFavorites()
        self.selectedPlace = myPlace
        place.text = myPlace.name
        detail.text = myPlace.longDescription
        if favPlaces.contains(selectedPlace.name!) {
            savedButton.isSelected = true
            savedButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        }else {
            savedButton.isSelected = false
            savedButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func zoomPlace(place: Place) {
        let miles : Double = 10 * 10 // region span
        let region = MKCoordinateRegion.init(center: place.coordinate, latitudinalMeters: miles, longitudinalMeters: miles)
        mapView.setRegion(region, animated: true)
    }

    
    @IBAction func savePlace(_ sender: UIButton) {
        let favPlaces = DataManager.sharedInstance.listFavorites()
        if favPlaces.contains(selectedPlace.name!) {
            DataManager.sharedInstance.deleteFavorite(place: selectedPlace)
            sender.isSelected = false
        }else {
            DataManager.sharedInstance.saveFavorites(place: selectedPlace)
            sender.isSelected = true

        }
        
        let newFav = DataManager.sharedInstance.listFavorites()
        print(newFav)
        
    }
    
    
    @IBAction func showFavPresentSheet(_ sender: UIButton) {
        let favoritesViewController = self.storyboard?.instantiateViewController(identifier: "FavoritesViewController") as! FavoritesViewController
        favoritesViewController.delegate = self
        if let sheet = favoritesViewController.sheetPresentationController{
            sheet.detents = [.large(), .medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(favoritesViewController, animated: true, completion: nil)
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let place = view.annotation as! Place
        updateInfoView(myPlace: place)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized!")
        case .notDetermined:
            print("We need to request authorization")
        default:
            print("Not authorized :(")
        }
    }
    
}

extension ViewController: PlacesFavoriteDelegate {
    func favoritePlace(name: String) {
        if let place = DataManager.sharedInstance.getPlaceByName(name: name) {
            zoomPlace(place: place)
            updateInfoView(myPlace: place)
        }
    }
}

