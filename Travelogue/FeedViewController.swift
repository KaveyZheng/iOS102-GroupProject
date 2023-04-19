//
//  FeedViewController.swift
//  Travelogue
//
//  Created by Kavey Zheng on 4/11/23.
//

import UIKit
import MapKit
import PhotosUI

class FeedViewController: UIViewController {

    var journal: Journal!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationView.identifier)
        mapView.delegate = self
        
        // UI Candy
        mapView.layer.cornerRadius = 12
        
    }
    
    func updateMapView() {
        // Make sure the task has image location.
        guard let imageLocation = journal.imageLocation else { return }

        // Get the coordinate from the image location. This is the latitude / longitude of the location.
        // https://developer.apple.com/documentation/mapkit/mkmapview
        let coordinate = imageLocation.coordinate

        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)

        // Add an annotation to the map view based on image location.
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

}

extension FeedViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationView.identifier, for: annotation) as? AnnotationView else {
            fatalError("Unable to dequeue Annotation")
        }

        annotationView.configure(with: journal.image)
        return annotationView
    }
}
