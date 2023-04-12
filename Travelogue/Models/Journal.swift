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
    let title: String
    let note: String
    
    var image: UIImage?
    var imageLocation: CLLocation?
    
    init(title: String, note: String) {
        self.title = title
        self.note = note
    }

    func set(_ image: UIImage, with location: CLLocation) {
        self.image = image
        self.imageLocation = location
    }
}
