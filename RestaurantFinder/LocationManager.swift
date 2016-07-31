//
//  LocationManager.swift
//  RestaurantFinder
//
//  Created by Kevin VanEvery on 7/31/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func getPermission() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}
