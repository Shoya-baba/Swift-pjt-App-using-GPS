//
//  burariApp.swift
//  burari
//
//  Created by user on 2023/06/12.
//

//元データ
//import SwiftUI
//
//@main
//struct burariApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
//ここまで

import SwiftUI
import UIKit
import CoreLocation

@main
struct burariApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


//class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
//    var locationManager : CLLocationManager?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//        locationManager = CLLocationManager()
//        locationManager!.delegate = self
//
//        locationManager!.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager!.distanceFilter = 10
//            locationManager!.activityType = .fitness
//            locationManager!.startUpdatingLocation()
//        }
//
//        return true
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let newLocation = locations.last else {
//            return
//        }
//
//        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
//
//        print("緯度: ", location.latitude, "経度: ", location.longitude)
//
//    }
//}
