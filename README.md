
# MyKindOfTown

Project Setup:

Use the "App" template.
The application should be enabled for portrait and landscape orientations.
Make the application Universal by using an adaptive Storyboard. If you use the Xcode template, this should happen almost automatically. The default behavior provides the adaptive layout that we want.

Map View Controller:

Create a view controller named MapViewController and used MapKit display a full screen `MapView.

Customize the the MapViews properties so that it does not show any of the Apple provided points of interests. We will be using our own. Disable the compass so that it doesn't over crowd our interface.

mapView.showsCompass = false
mapView.pointOfInterestFilter = .excludingAll
Add a partially transparent HUD (heads up display) UIView that will highlight details of a point of interest in our map. The view should contain two UILabels, one for the title and one for a description.

Add a UIButton to the view that is styled with a star to represent if a places is a favorite. Use a SFSybmol star and star.fill for the button image. Make sure set the button to star.fill for the selected state of the button. This can be accomplished in Storyboards or programmatically.

Map Annotations:

Annotate the map with points of interest in Chicago. Use the information in Data.plist for your annoations. Add 3 additional points of interest to your map.

The points of interest in Data.plist are represented as an Array of Dictionarys. You can read the plist file directly to the corresponding Swift types in your code.

Create a custom annotation view, PlaceMarkerView by subclassing MKMarkerAnnotations. You can style the markers as you like, this example is just a reference.

Implement the func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) method so that when an annotation is tapped, the title and description of the annotation appears in the display view.
