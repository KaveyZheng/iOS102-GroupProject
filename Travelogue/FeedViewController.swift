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
    //@IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationView.identifier)
//        mapView.delegate = self
//
//        // UI Candy
//        mapView.layer.cornerRadius = 12
//
//        updateMapView()
        
    }
    
    @IBAction func didTapCreate(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            // Request photo library access
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                switch status {
                case .authorized:
                    // The user authorized access to their photo library
                    // show picker (on main thread)
                    DispatchQueue.main.async {
                        self?.presentImagePicker()
                    }
                default:
                    // show settings alert (on main thread)
                    DispatchQueue.main.async {
                        // Helper method to show settings alert
                        self?.presentGoToSettingsAlert()
                    }
                }
            }
        } else {
            // Show photo picker
            presentImagePicker()
        }
    }
    
    private func presentImagePicker() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())

        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images

        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current

        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1

        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)

        // Set the picker delegate so we can receive whatever image the user picks.
        picker.delegate = self

        // Present the picker.
        present(picker, animated: true)
    }

    func updateMapView() {
        
    }
}

//extension FeedViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationView.identifier, for: annotation) as? AnnotationView else {
//            fatalError("Unable to dequeue Annotation")
//        }
//
//        // Configure the annotation view, passing in the task's image.
//        annotationView.configure(with: journal.image)
//        return annotationView
//    }
//}

extension FeedViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Dismiss the picker
        picker.dismiss(animated: true)

        // Get the selected image asset (we can grab the 1st item in the array since we only allowed a selection limit of 1)
        let result = results.first

        // Get image location
        // PHAsset contains metadata about an image or video (ex. location, size, etc.)
        guard let assetId = result?.assetIdentifier,
              let location = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject?.location else {
            return
        }

        print("📍 Image location coordinate: \(location.coordinate)")
        
        // Make sure we have a non-nil item provider
        guard let provider = result?.itemProvider,
              // Make sure the provider can load a UIImage
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

            // Handle any errors
            if let error = error {
              DispatchQueue.main.async { [weak self] in self?.showAlert(for:error) }
            
            }

            // Make sure we can cast the returned object to a UIImage
            guard let image = object as? UIImage else { return }

            print("🌉 We have an image!")

            DispatchQueue.main.async { [weak self] in
                self?.journal.set(image: image, with: location)
                //self?.updateMapView()
            }
        }
    }

}

extension FeedViewController {
    
    func presentGoToSettingsAlert() {
        let alertController = UIAlertController (
            title: "Photo Access Required",
            message: "In order to post a photo to complete a task, we need access to your photo library. You can allow access in Settings",
            preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }

        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    /// Show an alert for the given error
    private func showAlert(for error: Error? = nil) {
        let alertController = UIAlertController(
            title: "Oops...",
            message: "\(error?.localizedDescription ?? "Please try again...")",
            preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)

        present(alertController, animated: true)
    }
    
}
