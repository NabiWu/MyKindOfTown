//
//  PlaceMarkerView.swift
//  My kind of Town
//
//  Created by Bohan Wu on 2/11/22.
//

import Foundation
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
      willSet {
        clusteringIdentifier = "Place"
        displayPriority = .defaultLow
        markerTintColor = .systemRed
        glyphImage = UIImage(systemName: "pin.fill")
        }
  }
}



