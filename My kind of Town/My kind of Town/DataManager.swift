//
//  DataManager.swift
//  My kind of Town
//
//  Created by Bohan Wu on 2/11/22.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

public class DataManager {
  
    public static let sharedInstance = DataManager()
    
    private let defaults = UserDefaults.standard
    static var places : [Place] {
        return sharedInstance.loadAnnotationFromPlist()
    }
  //This prevents others from using the default '()' initializer
    fileprivate init() {
        
    }
  // Your code (these are just example functions, implement what you need)
    private func loadAnnotationFromPlist() -> [Place] {
        if let plist = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Data", ofType: "plist")!) {
            if let data = plist["places"] as? [[String : Any]] {
                let places = data.map { item -> Place in
                    let place = Place()
                    place.coordinate = CLLocationCoordinate2DMake(item["lat"]! as! CLLocationDegrees, item["long"] as! CLLocationDegrees)
                    place.name = item["name"] as? String
                    place.longDescription = item["description"] as? String
                    return place
                }
                return places
            }
        }
        return []
    }
    
    func loadRegion() -> MKCoordinateRegion {
        if let plist = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Data", ofType: "plist")!) {
            if let data = plist["region"] as? [NSNumber] {
                let coordinate = CLLocationCoordinate2DMake(data[0].doubleValue, data[1].doubleValue)
                let span = MKCoordinateSpan(latitudeDelta: data[2].doubleValue, longitudeDelta: data[3].doubleValue)
                return MKCoordinateRegion.init(center: coordinate, span: span)
            }
        }
        return MKCoordinateRegion.init()
    }
    
    func saveFavorites(place: Place) {
        if let key = place.name {
            defaults.set(place.longDescription, forKey: key)
            print("\(key) has saved")
        }
    }
    func deleteFavorite(place: Place) {
        if let key = place.name {
            defaults.removeObject(forKey: key)
            print("\(key) has deleted")
        }
    }
    func listFavorites() -> [String] {
        var favPlaces : [String] = []
        for place in DataManager.places {
            if let key = place.name {
                if defaults.string(forKey: key) != nil {
                    favPlaces.append(place.name!)
                }
            }
        }
        return favPlaces
    }
    
    func getPlaceByName(name : String) -> Place? {
        for place in DataManager.places {
            if place.name == name {
                return place
            }
        }
        return nil
    }
    
}
