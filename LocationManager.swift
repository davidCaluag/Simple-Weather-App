//
//  LocationManager.swift
//  DavidWeather
//
//  Created by David C on 2024-11-08.
//

import Foundation
import MapKit

class MyLocationManager:NSObject,ObservableObject,CLLocationManagerDelegate{
    @Published var location : CLLocation = CLLocation()
    @Published var coordinate : CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion(
        center:CLLocationCoordinate2D(latitude:43.4561,longitude:-79.7000)
        ,span:MKCoordinateSpan(latitudeDelta:1,longitudeDelta:1)
    )
    @Published var mapItems : [MKMapItem] = []
    @Published var mkRoute : MKRoute?
    let manager=CLLocationManager()

    override init(){
      //  self.location = CLLocation()
        super.init()

        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("location error")
            return
        }
        print("lat: \(location.coordinate.latitude) , lng: \(location.coordinate.longitude)")
        
        self.location = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
        print(#line,"Error \(error)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
			case.authorizedAlways:
				print("location services are available")
				break
			case.authorizedWhenInUse:
				print("authorized when in use")
				break
			case.notDetermined:
				manager.requestWhenInUseAuthorization()
				print("not determined")
				break
			case.restricted:
				print("restricted")
				break
			default:
				print("default")
        }
    }

    func searchLocation(for name : String){
        print(name)
       
        var items : [MKMapItem] = []
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = name
        region.center = self.location.coordinate // search around the user current location
        request.region = region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response , error in
            guard let res = response else {
                print(" error location not found")
                return
            }
            print(res.mapItems.count)
            items = res.mapItems
            self.mapItems = items
        }
    }
}
