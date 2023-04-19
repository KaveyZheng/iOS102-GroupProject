//
//  Journal.swift
//  Travelogue
//
//  Created by Kavey Zheng on 4/11/23.
//

import Foundation
import CoreLocation
import UIKit

class Journal {
    
    var image: UIImage?
    var imageLocation: CLLocation?

    init(image: UIImage, imageLocation: CLLocation) {
        self.image = nil
        self.imageLocation = nil
    }
    
    func set(_ image: UIImage, with location: CLLocation) {
        self.image = image
        self.imageLocation = location
    }

}
